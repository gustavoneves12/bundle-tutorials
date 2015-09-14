## One can require the configuration from another robot, for instance if one has
## a common robot class with minor modifications
#
# require 'config/robots/robot_class'

# Block evaluated at the very beginning of the Roby app initialization
Robot.init do
    require 'roby/schedulers/temporal'
    Roby.scheduler = Roby::Schedulers::Temporal.new
end

# Block evaluated to load the models this robot requires
Robot.requires do
#    Roby.app.load_default_models
    Syskit.conf.use_deployments_from 'tut_deployment'
    Syskit.conf.use_deployment 'controldev::RawJoystickToMotion2D' => 'converter'
end

# Block evaluated to configure the system, that is set up values in Roby's Conf
# and State
Robot.config do
    Conf.ready = true
end

# Block evaluated when the Roby app is fully setup, and the robot ready to
# start. This is where one usually adds permanent tasks and/or status lines
Robot.controller do
end

Robot.actions do
    require 'models/compositions/rock_control'
    require 'models/compositions/fence_monitor'
    require 'models/compositions/position_within_threshold_monitor'
    require 'models/profiles/rocks'
    require 'models/tasks/fenced_random_move'

    use_profile Tutorials::Profiles::RocksWithTransformer

    describe 'move randomly as long as in a 10 meter squere \
        around origin, move back to origin when passing the border'

    action_state_machine 'fenced_random_move' do
        random = state random_def

        fence_monitor = task Tutorials::Compositions::FenceMonitor.use(rock1_dev)

        random.depends_on fence_monitor

        origin = state to_origin_def.use(rock1_dev)

        target_monitor = task Tutorials::Compositions::PositionWithinThresholdMonitor.
            use(rock1_dev).with_arguments('target' => Types::Base::Position.new(0, 0, 0))

        origin.depends_on target_monitor

        start random
        transition random, fence_monitor.passed_fence_outwards_event, origin
        transition origin, target_monitor.reached_event, random
    end

    describe('random motion within a delimited area').
        returns(Tutorials::Tasks::FencedRandomMove).
        optional_arg('fence_size', 'size in meters of the fence around the origin', 3).
        optional_arg('threshold','size in meters we need to be from the origin to consider that we have reached it', 1)

    action_state_machine 'fenced_random_move_with_monitors' do
        random = state random_def

        random.monitor(
            'fence',
            random.rock_child.pose_samples_port,
            :fence_size => fence_size).
            trigger_on do |pose|
                pos = pose.position
                pos.x.abs > fence_size || pos.y.abs > fence_size
            end.
            emit crossed_fence_event

        origin = state to_origin_def.use(rock1_dev)

        origin.monitor(
            'reached_center',
            origin.rock_child.pose_samples_port,
            :threshold => threshold).
            trigger_on do |pose|
                pos = pose.position
                pos.abs < threshold && pos.y.abs < threshold
            end

        emit origin.success_event

        start random
        transition random, crossed_fence_event, origin
        transition origin, origin.success_event, random
    end
end

