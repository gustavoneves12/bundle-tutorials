require 'rock/models/services/motion2d_control_loop.rb'
require 'rock/models/services/pose.rb'

using_task_library 'rock_tutorial'
using_task_library 'tut_follower'
using_task_library 'tut_sensor'

module Tutorials
    class RockControl < Syskit::Composition
        add Rock::Services::Motion2DOpenLoopController, as: "cmd"
        add RockTutorial::RockTutorialControl, as: 'rock'
        cmd_child.connect_to rock_child
        
        conf 'slow',
            cmd_child => ['default', 'slow']
                
        export rock_child.pose_samples_port
        provides Rock::Services::Pose, as: 'pose'
        
        specialize cmd_child => TutFollower::Task do
            add Rock::Services::Pose, as: 'target_pose'
            add TutSensor::Task, as: 'sensor'
            
            target_pose_child.connect_to sensor_child.target_frame_port
            rock_child.connect_to sensor_child.local_frame_port
            sensor_child.connect_to cmd_child
        end
    end
end