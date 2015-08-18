require 'models/blueprints/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

module Tutorials
    profile 'Rocks' do
        define 'converter', Tutorials::RockControl.
            use(Controldev::RawJoystickToMotion2D).
            prefer_deployed_tasks(/rock_tutorial/)

        define 'random', Tutorials::RockControl.
            use(TutBrownian::Task).
            prefer_deployed_tasks(/rock_tutorial/)

        define 'random_slow', Tutorials::RockControl.
            use(TutBrownian::Task.use_conf('default', 'slow')).
            prefer_deployed_tasks(/rock_tutorial/)

        define 'random_slow2', Tutorials::RockControl.
            use(TutBrownian::Task.use_conf('slow')).
            prefer_deployed_tasks(/rock_tutorial/)

        define 'random_fast', Tutorials::RockControl.
            use(TutBrownian::Task.use_conf('default', 'fast')).
            prefer_deployed_tasks(/rock_tutorial/)

        define 'leader', Tutorials::RockControl.
            use(TutBrownian::Task).
            prefer_deployed_tasks(/target/)

        define 'follower', Tutorials::RockControl.
            use(TutFollower::Task, leader_def).
            prefer_deployed_tasks(/follower/)
    end
end