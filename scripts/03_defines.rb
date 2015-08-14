using_task_library 'controldev'
using_task_library 'rock_tutorial'
using_task_library 'tut_brownian'

import_types_from 'base'

module Tutorials
    data_service_type 'CommandGeneratorSrv' do
        output_port 'cmd', 'base/MotionCommand2D'
    end
end

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
    end
end

Syskit.conf.use_deployment 'controldev::JoystickTask' => 'joystick'
Syskit.conf.use_deployment 'controldev::RawJoystickToMotion2D' => 'converter'
Syskit.conf.use_deployment 'rock_tutorial::RockTutorialControl' => 'rock'
Syskit.conf.use_deployment 'tut_brownian::Task' => 'brownian'

define 'converter', Tutorials::RockControl.use(Controldev::RawJoystickToMotion2D)
define 'random', Tutorials::RockControl.use(TutBrownian::Task)
define 'random_slow', Tutorials::RockControl.use(TutBrownian::Task.use_conf('default', 'slow'))
define 'random_slow2', Tutorials::RockControl.use(TutBrownian::Task.use_conf('slow'))
define 'random_fast', Tutorials::RockControl.use(TutBrownian::Task.use_conf('default', 'fast'))