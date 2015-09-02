require 'models/devices/converter'
require 'models/devices/rock'

class OroGen::RockTutorial::RockTutorialControl
    driver_for Tutorials::Devices::Rock, as: 'driver'
end