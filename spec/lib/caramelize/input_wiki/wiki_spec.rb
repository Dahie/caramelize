require 'spec_helper'

describe Caramelize::InputWiki::Wiki do
  subject(:wiki) { described_class.new }


  describe '#latest_revisions' do
    let(:page1) { double }
    let(:page2) { double }
    let(:page3) { double }

    context 'no pages' do
      it 'return empty array' do
        expect(wiki.latest_revisions).to eq []
      end
    end

    context 'pages with revisions' do
      it 'returns list of latest pages' do
        wiki.titles = %w[allosaurus brachiosaurus]
        allow(wiki).to receive(:revisions_by_title)
          .with('allosaurus').and_return([page1, page2])
        allow(wiki).to receive(:revisions_by_title)
          .with('brachiosaurus').and_return([page3])

        expect(wiki.latest_revisions).to eq([page2, page3])
      end
    end
  end

  describe '#revisions_by_author' do
    context 'revisions is empty' do
      context 'and titles is empty' do
        it 'returns empty array' do
          allow(wiki).to receive(:titles).and_return []
          expect(wiki.revisions_by_title('title')).to eq []
        end
      end
    end

    context 'revisions are given' do
      context 'and title given' do
        it 'returns empty array' do
          pages = []
          home_1 = OpenStruct.new(title: 'Home', time: Time.parse('2015-01-23'))
          pages << home_1
          pages << OpenStruct.new(title: 'Example', time: Time.parse('2015-01-20'))
          pages << OpenStruct.new(title: 'Authors', time: Time.parse('2015-01-30'))
          home_2 = OpenStruct.new(title: 'Home', time: Time.parse('2014-01-23'))
          pages << home_2
          allow(wiki).to receive(:revisions).and_return pages
          expect(wiki.revisions_by_title('Home')).to eq [home_2, home_1]
        end
      end
    end
  end
end
