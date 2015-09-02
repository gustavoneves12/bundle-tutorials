require 'rock/models/services/pose'

module Tutorials
    module Devices
        device_type 'Rock' do
            provides Rock::Services::Pose
        end
    end
end