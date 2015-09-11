require 'rock/models/services/pose'

module Tutorials
    module Compositions
        class FenceMonitor < Syskit::Composition
           argument :fence_size, :default => 10
           event :passed_fence_outwards

           add Rock::Services::Pose, as: 'position'

           def in_fence?(p)
               p.x.abs < fence_size && p.y.abs < fence_size
           end

           script do
               position_r = position_child.pose_samples_port.reader
               poll do
                   if p = position_r.read_new
                       p = p.position
                       @last_p ||= p

                       if in_fence?(@last_p) && !in_fence?(p)
                           passed_fence_outwards_event.emit
                       end

                       @last_p = p
                   end
               end
           end
        end
    end
end