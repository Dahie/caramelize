# frozen_string_literal: true

require 'spec_helper'

# rubocop:todo RSpec/SpecFilePathFormat
describe Caramelize::SwapWikiLinks do # rubocop:todo RSpec/FilePath, RSpec/SpecFilePathFormat
  # rubocop:enable RSpec/SpecFilePathFormat
  describe '#run' do
    subject(:run) { filter.run }

    let(:filter) { described_class.new(body) }

    context 'with wiki link with title' do
      let(:body) { '[[statistics|Driver & Team Statistics]]' }

      it 'swaps title and target' do
        expect(run).to eq '[[Driver & Team Statistics|statistics]]'
      end
    end

    context 'with wiki title with spaces' do
      let(:body) { '[[Release 1 0]]' }

      it 'replaces space with dashes' do
        expect(run).to eq '[[Release 1 0|release_1_0]]'
      end
    end

    context 'with wiki title with dashes' do
      let(:body) { '[[Release-1.0]]' }

      it 'removes dots' do
        expect(run).to eq '[[Release-1.0|release-10]]'
      end
    end

    context 'with wiki link with spaces and without title' do
      let(:body) { '[[Intra wiki link]]' }

      it 'simples link to hyperlink' do
        expect(run).to eq '[[Intra wiki link|intra_wiki_link]]'
      end

      context 'with replace in full file' do
        let(:body) { File.read(File.join(['spec', 'fixtures', 'markup', 'swap-links-input.textile'])) }

        it 'returns as expected' do
          output_text = File.read(File.join(['spec', 'fixtures', 'markup', 'swap-links-output.textile']))
          expect(run).to eq output_text
        end
      end
    end
  end
end
