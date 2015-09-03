require 'models/services/distance_bearing_sensor'

OroGen::TutSensor::Task.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'
OroGen::TutSensor::TransformerTask.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'

class OroGen::TutSensor::TransformerTask
    transformer do
        associate_frame_to_ports 'ref', 'target_sensor_sample'
    end
end