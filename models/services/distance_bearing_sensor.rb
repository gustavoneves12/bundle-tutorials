import_types_from 'tut_sensor'

module Tutorials
    module Services
        data_service_type 'DistanceBearingSensor' do
            output_port 'samples', '/rock_tutorial/BearingDistanceSensor'
        end
    end
end