# frozen_string_literal: true

require "spec_helper"

describe Caramelize::FilterProcessor do
  subject(:processor) { described_class.new(input_wiki) }

  let(:filters) { [] }
  let(:input_wiki) { double(filters:) } # rubocop:todo RSpec/VerifiedDoubles
  let(:body) { "body" }

  # rubocop:todo RSpec/LeakyConstantDeclaration
  class ReverseFilter # rubocop:todo Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
    def initialize(body)
      @body = body
    end

    def run
      @body.reverse # rubocop:todo RSpec/InstanceVariable
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration

  describe "#run" do
    context "without any filters" do
      it "returns same revision body" do
        expect(processor.run(body)).to eql body
      end
    end

    context "with reverse filter" do
      let(:filters) { [ReverseFilter] }

      it "returns reversed body" do
        expect(processor.run(body)).to eql body.reverse
      end
    end
  end
end
