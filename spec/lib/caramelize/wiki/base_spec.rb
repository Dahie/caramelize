require 'spec_helper'

describe Caramelize::Wiki::Base do

  describe '#revisions_by_author' do
    let(:wiki) { described_class.new }

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
