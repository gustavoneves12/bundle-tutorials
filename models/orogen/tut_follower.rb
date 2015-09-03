require 'rock/models/services/motion2d_control_loop.rb'

class OroGen::TutFollower::Task
    provides Rock::Services::Motion2DOpenLoopController, as: 'cmd'
    transformer do
        associate_frame_to_ports 'ref', 'bearing_distance', 'cmd'
    end
end