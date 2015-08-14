using_task_library 'controldev'
using_task_library 'rock_tutorial'

module Tutorials
    class RockControl < Syskit::Composition
                
        add Controldev::JoystickTask, as: "joystick"

        add Controldev::RawJoystickToMotion2D, as: "converter"
        
        add RockTutorial::RockTutorialControl, as: "rock"

        joystick_child.connect_to converter_child
        converter_child.connect_to rock_child
    end
end

Syskit.conf.use_deployment 'controldev::JoystickTask' => 'joystick'
Syskit.conf.use_deployment 'controldev::RawJoystickToMotion2D' => 'converter'
Syskit.conf.use_deployment 'rock_tutorial::RockTutorialControl' => 'rock'


add_mission Tutorials::RockControl