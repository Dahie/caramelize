# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::InputWiki::Wiki do
  subject(:wiki) { described_class.new }

  describe '#latest_revisions' do
    let(:page1) { double }
    let(:page2) { double }
    let(:page3) { double }

    context 'without pages' do
      it 'return empty array' do
        expect(wiki.latest_revisions).to eq []
      end
    end

    context 'with pages with revisions' do
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
    context 'with revisions is empty' do
      context 'with titles is empty' do
        it 'returns empty array' do
          allow(wiki).to receive(:titles).and_return []
          expect(wiki.revisions_by_title('title')).to eq []
        end
      end
    end

    context 'with revisions are given' do
      context 'with title given' do
        it 'returns empty array' do
          pages = []
          home1 = double(title: 'Home', time: Time.parse('2015-01-23'))
          pages << home1
          pages << double(title: 'Example', time: Time.parse('2015-01-20'))
          pages << double(title: 'Authors', time: Time.parse('2015-01-30'))
          home2 = double(title: 'Home', time: Time.parse('2014-01-23'))
          pages << home2
          allow(wiki).to receive(:revisions).and_return pages
          expect(wiki.revisions_by_title('Home')).to eq [home2, home1]
        end
      end
    end
  end
end
