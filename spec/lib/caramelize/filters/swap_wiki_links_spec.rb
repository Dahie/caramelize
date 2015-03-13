require 'spec_helper'

describe Caramelize::SwapWikiLinks do

  describe :run do
    let(:filter) { Caramelize::SwapWikiLinks.new }
    context 'hyperlink' do
      it 'should switch title and target' do
        body = '[[Title|http://target]]'
        expect(filter.run(body)).to eq '[[http://target|Title]]'
      end
      it 'should simple link to hyperlink' do
        body = '[[Intra wiki link]]'
        expect(filter.run(body)).to eq '[[Intra wiki link|Intra_wiki_link]]'
      end
    end
  end
end
