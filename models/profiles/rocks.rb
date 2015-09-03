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
           
           define 'converter', Tutorials::Compositions::RockControl.
               use(converter_dev, rock1_dev)
           
           define 'random', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task, rock1_dev)
   
      
           define 'random2', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task, rock2_dev)
   
           define 'random_slow', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task.with_conf('default', 'slow'), rock1_dev)
   
           define 'random_slow2', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task, rock1_dev).with_conf('slow')
   
           define 'random_fast', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task.use_conf('default', 'fast'))
   
           define 'leader', Tutorials::Compositions::RockControl.
               use(OroGen::TutBrownian::Task, rock1_dev)
   
           define 'follower', Tutorials::Compositions::RockFollower.
               use(OroGen::TutFollower::Task, rock2_dev)
       end
       
       profile 'RocksWithoutTransformer' do
           use_profile BaseRocks
           define 'follower', follower_def.use(OroGen::TutSensor::Task, 'target_pose' => leader_def)
       end

       profile 'RocksWithTransformer' do
           use_profile BaseRocks

           transformer do
               frames 'leader', 'follower', 'world'
               dynamic_transform rock1_dev.prefer_deployed_tasks(/targert/), 'leader' => 'world'
               dynamic_transform rock2_dev.prefer_deployed_tasks(/follower/), 'follower' => 'world'
           end

           define 'follower', follower_def.
           use(OroGen::TutSensor::TransformerTask).
           use_frames('target' => 'leader', 'ref' => 'follower', 'world' => 'world')
       end
   end
end