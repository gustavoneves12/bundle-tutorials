require 'models/compositions/rock_control'
using_task_library 'controldev'
using_task_library 'tut_brownian'
using_task_library 'tut_follower'

module Tutorials
    module Profiles
        profile 'BaseRocks' do
           robot do
               device(Tutorials::Devices::Converter, as: 'converter')                
               
               device(Tutorials::Devices::Rock, as: "rock1").
                   prefer_deployed_tasks(/target/)
                   
               device(Tutorials::Devices::Rock, as: "rock2").
                   prefer_deployed_tasks(/follower/)
                
           end
           
           define 'converter', Tutorials::RockControl.
               use(converter_dev, rock1_dev)
           
           define 'random', Tutorials::RockControl.
               use(TutBrownian::Task, rock1_dev)
   
      
           define 'random2', Tutorials::RockControl.
               use(TutBrownian::Task, rock2_dev)
   
           define 'random_slow', Tutorials::RockControl.
               use(TutBrownian::Task.with_conf('default', 'slow'), rock1_dev)
   
           define 'random_slow2', Tutorials::RockControl.
               use(TutBrownian::Task, rock1_dev).with_conf('slow')
   
           define 'random_fast', Tutorials::RockControl.
               use(TutBrownian::Task.use_conf('default', 'fast'))
   
           define 'leader', Tutorials::RockControl.
               use(TutBrownian::Task, rock1_dev)
   
           define 'follower', Tutorials::RockFollower.
               use(TutFollower::Task, rock2_dev)
       end
       
       profile 'RocksWithoutTransformer' do
           use_profile BaseRocks
           define 'follower', follower_def.use(TutSensor::Task, 'target_pose' => leader_def)
       end
       
       profile 'RocksWithTransformer' do
           use_profile BaseRocks
           define 'follower', follower_def.use(TutSensor::TransformerTask)
       end
   end
end