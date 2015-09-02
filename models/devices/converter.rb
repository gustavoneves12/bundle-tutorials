require 'rock/models/services/motion2d_control_loop.rb'

module Tutorials
    module Devices
        device_type 'Converter' do
            provides Rock::Services::Motion2DOpenLoopController
        end
    end
end