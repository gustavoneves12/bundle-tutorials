module Tutorials
    module Tasks
        class FencedRandomMove < Roby::Task
            terminates
            event :crossed_fence
        end
    end
end