require 'smartdown/api/question'

module Smartdown
  module Api
    class MultipleChoice < Question
      def options
        question = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice}
        question.choices.map do |choice|
          OpenStruct.new(:label => choice[1], :value => choice[0])
        end
      end

      def name
        question = elements.find{|element| element.is_a? Smartdown::Model::Element::Question::MultipleChoice}
        question.name
      end

    end
  end
end
