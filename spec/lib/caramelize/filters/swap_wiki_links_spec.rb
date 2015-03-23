require 'spec_helper'

describe Caramelize::SwapWikiLinks do

  describe :run do
    let(:filter) { Caramelize::SwapWikiLinks.new }
    context 'wiki link' do
      it 'should switch title and target' do
        body = '[[statistics|Driver & Team Statistics]]'
        expect(filter.run(body)).to eq '[[Driver & Team Statistics|statistics]]'
      end
      it 'should replace space with dashes' do
        body = '[[Release 1 0]]'
        expect(filter.run(body)).to eq '[[Release 1 0|Release_1_0]]'
      end
      it 'should remove dots' do
        body = '[[Release 1.0]]'
        expect(filter.run(body)).to eq '[[Release 1.0|Release_10]]'
      end
      it 'should simple link to hyperlink' do
        body = '[[Intra wiki link]]'
        expect(filter.run(body)).to eq '[[Intra wiki link|Intra_wiki_link]]'
      end
      context 'replace in full file' do
        it 'returns as expected' do
          input_text = File.open(File.join(['spec', 'fixtures', 'markup', 'swap-links-input.textile']), 'r').read
          output_text = File.open(File.join(['spec', 'fixtures', 'markup', 'swap-links-output.textile']), 'r').read
          expect(filter.run(input_text)).to eq output_text
        end
      end
    end
  end
end
