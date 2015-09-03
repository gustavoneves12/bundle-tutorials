require 'models/devices/converter'
require 'models/devices/rock'

class OroGen::RockTutorial::RockTutorialControl
    driver_for Tutorials::Devices::Rock, as: 'driver'
    transformer do
        transform_output 'pose_samples', 'body' => 'world'
        associate_frame_to_ports 'body', 'motion_command'
    end
end