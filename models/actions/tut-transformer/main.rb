require 'models/profiles/rocks'
module Tutorials
    module Actions
        class Main < Roby::Actions::Interface
          use_profile Tutorials::RocksWithTransformer
        end
    end
end