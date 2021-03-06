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
          {h1: "This is my title"},
          {blank_line: "\n", element: {line: "This is a paragraph of text with stuff"}},
          {blank_line: "\n", element: {line: "that flows along"}},
          {blank_line: "\n\n", element: {line: "Another paragraph of text"}},
          {blank_line: "\n", element: {blank: nil}},
        ]
      })
    }

    it "parses markdown blocks separated by multiple newlines" do
      expect(parser).to parse("a\n\n\nb\n")
    end
  end

  describe "front matter and body" do
    let(:source) {
<<SOURCE
---
name: My node
---

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
          {h1: "This is my title"},
          {blank_line: "\n", element: {line: "A paragraph"}},
          {blank_line: "\n", element: {blank: nil}},
        ]
      })
    end
  end

  describe "body with multiple choice options" do
    let(:source) {
<<SOURCE
# This is my title

[choice: my_question]
* yes: Yes
* no: No
SOURCE
     }

    it do
      should parse(source).as({
        body: [
          {h1: "This is my title"},
          {blank_line: "\n",
           element: {
             multiple_choice: {
              identifier: "my_question",
              options: [
                {value: "yes", label: "Yes"},
                {value: "no", label: "No"}
              ],
              option_pairs: []}
            }
          }
        ]
      })
    end
  end

  describe "body and next_node rules" do
    let(:source) {
<<SOURCE
# This is my title

[choice: my_question]
* yes: Yes
* no: No

# Next node rules

* pred1? => outcome
SOURCE
     }

    it {
      should parse(source).as({
        body: [
          {h1: "This is my title"},
          {blank_line: "\n",
           element: {
             multiple_choice: {
              identifier: "my_question",
              options: [
                {value: "yes", label: "Yes"},
                {value: "no", label: "No"}
              ],
              option_pairs: []
              }
            }
          },
          {blank_line: "\n", element: {h1: "Next node rules"}},
          {blank_line: "\n", element: 
            {next_node_rules: [{rule: {predicate: {named_predicate: "pred1?"}, outcome: "outcome"}}]}
          }
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
          Smartdown::Model::Element::MarkdownHeading.new("This is my title"),
          Smartdown::Model::Element::MarkdownLine.new("\n"),
          Smartdown::Model::Element::Question::MultipleChoice.new("my_question", "yes"=>"Yes", "no"=>"No"),
          Smartdown::Model::Element::MarkdownLine.new("\n"),
          Smartdown::Model::Element::MarkdownHeading.new("Next node rules"),
          Smartdown::Model::Element::MarkdownLine.new("\n"),
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

  describe "body with conditional" do
    let(:source) {
<<SOURCE
$IF pred1?

Text when true

$ELSE

Text when false

$ENDIF
SOURCE
     }

    it {
      should parse(source).as({
        body: [
          { conditional: {
            predicate: {named_predicate: "pred1?"},
            true_case: [
              {line: "Text when true"},
              {blank: "\n"},
              {blank: "\n"},
            ],
            false_case: [
              {line: "Text when false"},
              {blank: "\n"},
              {blank: "\n"},
            ]
          }}
        ]
      })
    }
  end

  context "body with extra trailing newlines" do
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
          {h1: "This is my title"},
          {blank_line: "\n", element: {line: "This is a paragraph of text with stuff"}},
          {blank_line: "\n", element: {line: "that flows along"}},
          {blank_line: "\n\n", element: {line: "Another paragraph of text"}},
          {blank_line: "\n\n\n", element: {blank: nil}},
        ]
      })
    }
  end

  context "blank line with a tab on it" do

    let(:source) {
<<SOURCE
# Lovely title

line of content
SOURCE
}

    it "doesn't blow up" do
      should parse(source).as({
        body: [
          {h1: "Lovely title" },
          {blank_line: "\n", element: {line: "line of content" }},
          {blank_line: "\n", element: {blank: nil }},
        ]
      })
    end
  end
end
