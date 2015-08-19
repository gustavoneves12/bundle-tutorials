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
    require 'models/profiles/rocks'
    use_profile Tutorials::RocksWithTransformer
end

