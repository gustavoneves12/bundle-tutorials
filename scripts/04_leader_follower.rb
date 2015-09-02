require 'rock/models/blueprints/backwards/pose.rb'
import_types_from 'base'

module Tutorials
    data_service_type 'CommandGeneratorSrv' do
        output_port 'cmd', 'base/MotionCommand2D'
    end
end


using_task_library 'controldev'
using_task_library 'rock_tutorial'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'
using_task_library 'tut_sensor'


TutFollower::Task.provides Tutorials::CommandGeneratorSrv, as: 'cmd'
TutBrownian::Task.provides Tutorials::CommandGeneratorSrv, as: 'cmd'
Controldev::RawJoystickToMotion2D.provides Tutorials::CommandGeneratorSrv, as: 'cmd'

module Tutorials
    class RockControl < Syskit::Composition
        
        add Controldev::JoystickTask, as: 'joystick'
        
        add Controldev::RawJoystickToMotion2D, as: 'converter'
        
        add CommandGeneratorSrv, as: "cmd"
        
        add RockTutorial::RockTutorialControl, as: 'rock'
        
        joystick_child.connect_to converter_child
        cmd_child.connect_to rock_child
        
        conf 'slow', cmd_child => ['default', 'slow']
            
        export rock_child.pose_samples_port
        provides Base::PoseSrv, as: 'pose'
    end
end

Tutorials::RockControl.specialize Tutorials::RockControl.cmd_child => TutFollower::Task do
  add Base::PoseSrv, :as => "target_pose"
  add TutSensor::Task, :as => 'sensor'
  
  target_pose_child.connect_to sensor_child.target_frame_port
  rock_child.connect_to sensor_child.local_frame_port
  sensor_child.connect_to cmd_child
end

Syskit.conf.use_deployments_from 'tut_deployment'
Syskit.conf.use_deployment 'controldev::RawJoystickToMotion2D' => 'converter'

define 'converter', Tutorials::RockControl.use(Controldev::RawJoystickToMotion2D)
define 'random', Tutorials::RockControl.use(TutBrownian::Task)
define 'random_slow', Tutorials::RockControl.use(TutBrownian::Task.use_conf('default', 'slow'))
define 'random_slow2', Tutorials::RockControl.use(TutBrownian::Task.use_conf('slow'))
define 'random_fast', Tutorials::RockControl.use(TutBrownian::Task.use_conf('default', 'fast'))
    
define 'leader', Tutorials::RockControl.
    use(TutBrownian::Task).
    use_deployments(/target/)
    
define 'follower', Tutorials::RockControl.
    use(TutFollower::Task, leader_def).
    use_deployments(/follower/)
