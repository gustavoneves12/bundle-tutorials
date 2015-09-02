require 'models/services/distance_bearing_sensor'

TutSensor::Task.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'

TutSensor::TransformerTask.provides Tutorials::Services::DistanceBearingSensor, as: 'sensor'