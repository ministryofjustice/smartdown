module Smartdown
  class Engine
    class PredicateEvaluator
      def evaluate(predicate, state)
        evaluator_for(predicate).call(state)
      end

    private
      def evaluator_for(predicate)
        case predicate
        when Smartdown::Model::Predicate::Equality
          ->(state) { state.get(predicate.varname) == predicate.expected_value }
        when Smartdown::Model::Predicate::SetMembership
          ->(state) { predicate.values.include?(state.get(predicate.varname)) }
        else
          raise "Unknown predicate type #{predicate.class}"
        end
      end
    end
  end
end
