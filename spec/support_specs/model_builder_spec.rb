require 'support/model_builder'

describe ModelBuilder do
  subject(:builder) { described_class.new }

  describe "#flow" do
    let(:node1) {
      Smartdown::Model::Node.new("check-uk-visa", [
        Smartdown::Model::Element::MarkdownHeading.new("Check uk visa"),
        Smartdown::Model::Element::MarkdownParagraph.new("This is the paragraph"),
        Smartdown::Model::Element::StartButton.new("what_passport_do_you_have?")
      ])
    }

    let(:node2) {
      Smartdown::Model::Node.new("what_passport_do_you_have?", [
        Smartdown::Model::Element::MarkdownHeading.new("What passport do you have?"),
        Smartdown::Model::Element::MultipleChoice.new(nil, {"greek" => "Greek", "british" => "British"}),
        Smartdown::Model::NextNodeRules.new([
          Smartdown::Model::Rule.new(
            Smartdown::Model::Predicate::Named.new("eea_passport?"),
            "outcome_no_visa_needed"
          )
        ])
      ])
    }

    let(:expected) {
      Smartdown::Model::Flow.new("check-uk-visa", [node1, node2])
    }

    it "builds a flow using a dsl" do
      model = builder.flow("check-uk-visa") do
        node("check-uk-visa") do
          heading("Check uk visa")
          paragraph("This is the paragraph")
          start_button("what_passport_do_you_have?")
        end

        node("what_passport_do_you_have?") do
          heading("What passport do you have?")
          multiple_choice(
            greek: "Greek",
            british: "British"
          )
          next_node_rules do
            rule do
              named_predicate("eea_passport?")
              outcome("outcome_no_visa_needed")
            end
          end
        end
      end

      expect(model).to eq(expected)
    end
  end

  describe "#node" do
    it "builds a node" do
      expect(builder.node("foo")).to be_a(Smartdown::Model::Node)
    end
  end

  describe "#conditional" do
    let(:expected) {
      Smartdown::Model::Element::Conditional.new(
        Smartdown::Model::Predicate::Named.new("pred?"),
        [Smartdown::Model::Element::MarkdownParagraph.new("True case")],
        [Smartdown::Model::Element::MarkdownParagraph.new("False case")]
      )
    }

    subject(:model) {
      builder.conditional do
        named_predicate "pred?"
        true_case do
          paragraph("True case")
        end
        false_case do
          paragraph("False case")
        end
      end
    }

    it "builds a conditional" do
      should eq(expected)
    end
  end

  describe "#rule" do
    let(:predicate) { Smartdown::Model::Predicate::Named.new("my_pred") }

    it "builds a rule using predicate and outcome" do
      expect(builder.rule(predicate, "my_next_node")).to eq(Smartdown::Model::Rule.new(predicate, "my_next_node"))
    end

    it "builds a rule using dsl block" do
      expect(builder.rule { named_predicate("my_pred"); outcome("my_next_node") }).to eq(Smartdown::Model::Rule.new(predicate, "my_next_node"))
    end
  end

  describe ModelBuilder::DSL do
    it "exposes a #build_flow method" do
      my_class = Class.new do
        include ModelBuilder::DSL
      end
      instance = my_class.new
      flow = instance.build_flow("name") do
        node("check-uk-visa") {}
      end

      expect(flow).to be_a(Smartdown::Model::Flow)
    end
  end
end
