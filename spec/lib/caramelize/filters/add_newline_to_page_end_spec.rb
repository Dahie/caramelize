# frozen_string_literal: true

require 'spec_helper'

# rubocop:todo RSpec/SpecFilePathFormat
describe Caramelize::Filter::AddNewlineToPageEnd do # rubocop:todo RSpec/FilePath, RSpec/SpecFilePathFormat
  # rubocop:enable RSpec/SpecFilePathFormat
  describe '#run' do
    subject(:run) { filter.run }

    let(:filter) { described_class.new(body) }

    context 'with newline on body end' do
      let(:body) { "Here is a sample body\n" }

      it 'adds no newline character' do
        expect(run).to eq "Here is a sample body\n"
      end
    end

    context 'without newline on body end' do
      let(:body) { 'Here is a sample body' }

      it 'adds newline character' do
        expect(run).to eq "Here is a sample body\n"
      end
    end
  end
end
