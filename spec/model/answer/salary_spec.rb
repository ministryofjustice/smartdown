require 'smartdown/model/answer/date'
require 'smartdown/model/element/question/date'

describe Smartdown::Model::Answer::Salary do
  let(:salary_string) { "500-week" }
  let(:question) { Smartdown::Model::Element::Question::Date.new("a_date") }
  subject(:instance) { described_class.new(question, salary_string) }

  specify { expect(instance.period).to eql('week') }
  specify { expect(instance.amount_per_period).to eql(500.00) }

  it "as a string, it should declare itself in the initial format provided" do
    expect(instance.to_s).to eql("500.00 per week")
  end

  context "declared by week" do
    let(:salary_string) { "500-week" }
    specify { expect(instance.value).to eql 500.0 * 52 }
  end

  context "declared by month" do
    let(:salary_string) { "2000-month" }
    specify { expect(instance.value).to eql 2000.0 * 12 }
  end

  context "declared by year" do
    let(:salary_string) { "20000-year" }
    specify { expect(instance.value).to eql 20000.0 }
  end


  describe "comparisons" do
    let(:salary_string) { "1200-week" } # equivalent to 62,400 yearly or 5200 monthly

    context "comparing against ::Floats" do
      specify { expect(instance == 62400.0).to eql true }

      specify { expect(instance < 62400.1).to eql true }
      specify { expect(instance < 62400.0).to eql false }
      specify { expect(instance < 62399.9).to eql false }

      specify { expect(instance > 62400.1).to eql false }
      specify { expect(instance > 62400.0).to eql false }
      specify { expect(instance > 62399.9).to eql true }

      specify { expect(instance <= 62400.1).to eql true }
      specify { expect(instance <= 62400.0).to eql true }
      specify { expect(instance <= 62399.9).to eql false }

      specify { expect(instance >= 62400.1).to eql false }
      specify { expect(instance >= 62400.0).to eql true }
      specify { expect(instance >= 62399.9).to eql true }
    end

    context "comparing against strings" do
      specify { expect(instance == "1200-week").to eql true }
      specify { expect(instance == "5200-month").to eql true }
      specify { expect(instance == "62400-year").to eql true }
      specify { expect(instance == "10-month").to eql false }

      specify { expect(instance < "62400.1-year").to eql true }
      specify { expect(instance < "5200.0-month").to eql false }
      specify { expect(instance < "1199.9-week").to eql false }

      specify { expect(instance > "1200.1-week").to eql false }
      specify { expect(instance > "62400-year").to eql false }
      specify { expect(instance > "5199.9-month").to eql true }

      specify { expect(instance <= "62400.1-year").to eql true }
      specify { expect(instance <= "5200.0-month").to eql true }
      specify { expect(instance <= "1199.9-week").to eql false }

      specify { expect(instance >= "1200.1-week").to eql false }
      specify { expect(instance >= "62400-year").to eql true }
      specify { expect(instance >= "5199.9-month").to eql true }
    end

    context "comparing against Answer::Salaries" do
      specify { expect(instance == described_class.new(nil, "1200-week")).to eql true }

      specify { expect(instance < described_class.new(nil, "1200.1-week")).to eql true }
      specify { expect(instance < described_class.new(nil, "1200.0-week")).to eql false }
      specify { expect(instance < described_class.new(nil, "1199.9-week")).to eql false }

      specify { expect(instance > described_class.new(nil, "1200.1-week")).to eql false }
      specify { expect(instance > described_class.new(nil, "1200.0-week")).to eql false }
      specify { expect(instance > described_class.new(nil, "1199.9-week")).to eql true }

      specify { expect(instance <= described_class.new(nil, "1200.1-week")).to eql true }
      specify { expect(instance <= described_class.new(nil, "1200.0-week")).to eql true }
      specify { expect(instance <= described_class.new(nil, "1199.9-week")).to eql false }

      specify { expect(instance >= described_class.new(nil, "1200.1-week")).to eql false }
      specify { expect(instance >= described_class.new(nil, "1200.0-week")).to eql true }
      specify { expect(instance >= described_class.new(nil, "1199.9-week")).to eql true }
    end
  end
end