require 'models/services/distance_bearing_sensor'

OroGen::TutSensor::Task.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'
OroGen::TutSensor::TransformerTask.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'
#
#class TutSensor::TransformerTask
#    transformer do
#        transform 'target', 'ref'
#        transform 'ref', 'world'
#        max_latency 1
#    end
#end