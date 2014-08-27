require 'smartdown/model/predicate/comparison/base'
require 'date'

module Smartdown
  module Model
    module Predicate
      module Comparison
        class Less < Base
          def evaluate(variable)
            if /(\d{4})-(\d{1,2})-(\d{1,2})/.match(value)
              Date.parse(variable) < Date.parse(value)
            else
              variable < value
            end
          end
        end
      end
    end
  end
end