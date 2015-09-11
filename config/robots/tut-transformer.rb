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
end

