require 'rock/models/services/motion2d_control_loop.rb'
Controldev::RawJoystickToMotion2D.provides Rock::Services::Motion2DOpenLoopController, as: 'cmd'