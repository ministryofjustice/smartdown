require_relative "base"

module Smartdown
  module Model
    module Answer
      class MultipleChoice < Base
        def value_type
          ::String
        end
      end
    end
  end
end