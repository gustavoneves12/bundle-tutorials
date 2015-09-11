require 'rock/models/services/pose'

module Tutorials
    module Compositions
        class PositionWithinThresholdMonitor < Syskit::Composition
            argument :target
            argument :threshold, :default => 1
            event :reached

            add Rock::Services::Pose, as: 'position'

            def in_threshold?(p)
                (p - target).norm < threshold
            end

            script do
                position_r = position_child.pose_samples_port.reader
                poll do
                    if (p = position_r.read_new) && in_threshold?(p.position)
                        reached_event.emit
                    end
                end
            end
        end
    end
end