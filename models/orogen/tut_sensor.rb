require 'models/services/distance_bearing_sensor'

TutSensor::Task.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'
TutSensor::TransformerTask.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'

class TutSensor::TransformerTask
    transformer do
        transform 'target', 'ref'
        transform 'ref', 'world'
        max_latency 1
    end
end