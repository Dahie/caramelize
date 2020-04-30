require 'spec_helper'

describe Caramelize::SwapWikiLinks do
  describe '#run' do
    let(:filter) { described_class.new(body) }
    subject { filter.run }

    context 'wiki link with title' do
      let(:body) { '[[statistics|Driver & Team Statistics]]' }

      it 'swaps title and target' do
        is_expected.to eq '[[Driver & Team Statistics|statistics]]'
      end
    end

    context 'wiki title with spaces' do
      let(:body) { '[[Release 1 0]]' }

      it 'replaces space with dashes' do
        is_expected.to eq '[[Release 1 0|Release_1_0]]'
      end
    end

    context 'wiki title with dashes' do
      let(:body) { '[[Release 1.0]]' }

      it 'removes dots' do
        is_expected.to eq '[[Release 1.0|Release_10]]'
      end
    end

    context 'wiki link with spaces and without title' do
      let(:body) { '[[Intra wiki link]]' }

      it 'simples link to hyperlink' do
        is_expected.to eq '[[Intra wiki link|Intra_wiki_link]]'
      end

      context 'replace in full file' do
        let(:body) { File.open(File.join(['spec', 'fixtures', 'markup', 'swap-links-input.textile']), 'r').read }

        it 'returns as expected' do
          output_text = File.open(File.join(['spec', 'fixtures', 'markup', 'swap-links-output.textile']), 'r').read
          is_expected.to eq output_text
        end
      end
    end
  end
end
