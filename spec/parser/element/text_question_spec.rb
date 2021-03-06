require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/text_question'

describe Smartdown::Parser::Element::TextQuestion do
  subject(:parser) { described_class.new }

  context "with question tag" do
    let(:source) { "[text: hometown]" }

    it "parses" do
      should parse(source).as(
        text: {
          identifier: "hometown",
          option_pairs: [],
        },
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Text.new("hometown")) }
    end
  end

  context "with question tag and alias" do
    let(:source) { "[text: hometown, alias: birthplace]" }

    it "parses" do
      should parse(source).as(
        text: {
          identifier: "hometown",
          option_pairs:[
            {
              key: 'alias',
              value: 'birthplace',
            }
          ]
        }
      )
    end

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Text.new("hometown", "birthplace")) }
    end
  end

end
