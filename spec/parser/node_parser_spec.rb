require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'

describe Smartdown::Parser::NodeParser do
  subject(:parser) { described_class.new }

  describe "body only" do
    let(:source) {
<<SOURCE
# This is my title

This is a paragraph of text with stuff
that flows along

Another paragraph of text
SOURCE
     }

    it {
      should parse(source).as({
        body: [
          {h1: "This is my title\n"},
          {p: "This is a paragraph of text with stuff\nthat flows along\n"},
          {p: "Another paragraph of text\n"}
        ]
      })
    }
  end

  describe "front matter and body" do
    let(:source) {
<<SOURCE
name: My node

# This is my title

A paragraph
SOURCE
     }

    it do
      should parse(source).as({
        front_matter: [
          {name: "name", value: "My node"}
        ],
        body: [
          {h1: "This is my title\n"},
          {p: "A paragraph\n"}
        ]
      })
    end
  end

  describe "body with multiple choice options" do
    let(:source) {
<<SOURCE
# This is my title

* yes: Yes
* no: No
SOURCE
     }

    it do
      should parse(source).as({
        body: [
          {h1: "This is my title\n"},
          {multiple_choice: [
            {value: "yes", label: "Yes"},
            {value: "no", label: "No"}
          ]}
        ]
      })
    end
  end

  describe "body and next_node rules" do
    let(:source) {
<<SOURCE
# This is my title

* yes: Yes
* no: No

# Next node rules

* pred1? => outcome
SOURCE
     }

    it {
      should parse(source).as({
        body: [
          {h1: "This is my title\n"},
          {multiple_choice: [
            {value: "yes", label: "Yes"},
            {value: "no", label: "No"}
          ]},
          {h1: "Next node rules\n"},
          {next_node_rules: [{rule: {predicate: {named_predicate: "pred1?"}, outcome: "outcome"}}]}
        ]
      })
    }

    describe "transformed" do
      let(:node_name) { "my_node" }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      let(:expected_elements) {
        [
          {:h1=>"This is my title\n"},
          Smartdown::Model::Question::MultipleChoice.new(node_name, "yes"=>"Yes", "no"=>"No"),
          {:h1=>"Next node rules\n"},
          Smartdown::Model::NextNodeRules.new([
            Smartdown::Model::Rule.new(Smartdown::Model::Predicate::Named.new("pred1?"), "outcome")
          ])
        ]
      }

      let(:expected_node_model) {
        Smartdown::Model::Node.new(node_name, expected_elements)
      }

      it { should eq(expected_node_model) }
    end
  end
end
