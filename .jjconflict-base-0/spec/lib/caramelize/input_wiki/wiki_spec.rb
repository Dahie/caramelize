# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::InputWiki::Wiki do
  subject(:wiki) { described_class.new }

  describe '#latest_revisions' do
    let(:page1) { double } # rubocop:todo RSpec/IndexedLet
    let(:page2) { double } # rubocop:todo RSpec/IndexedLet
    let(:page3) { double } # rubocop:todo RSpec/IndexedLet

    context 'without pages' do
      it 'return empty array' do
        expect(wiki.latest_revisions).to eq []
      end
    end

    context 'with pages with revisions' do
      it 'returns list of latest pages' do # rubocop:todo RSpec/ExampleLength
        wiki.titles = %w[allosaurus brachiosaurus]
        allow(wiki).to receive(:revisions_by_title) # rubocop:todo RSpec/SubjectStub
          .with('allosaurus').and_return([page1, page2])
        allow(wiki).to receive(:revisions_by_title) # rubocop:todo RSpec/SubjectStub
          .with('brachiosaurus').and_return([page3])

        expect(wiki.latest_revisions).to eq([page2, page3])
      end
    end
  end

  describe '#revisions_by_author' do
    context 'with revisions is empty' do
      context 'with titles is empty' do
        it 'returns empty array' do
          allow(wiki).to receive(:titles).and_return [] # rubocop:todo RSpec/SubjectStub
          expect(wiki.revisions_by_title('title')).to eq []
        end
      end
    end

    context 'with revisions are given' do
      context 'with title given' do
        it 'returns empty array' do # rubocop:todo RSpec/ExampleLength
          pages = []
          home1 = double(title: 'Home', time: Time.parse('2015-01-23')) # rubocop:todo RSpec/VerifiedDoubles
          pages << home1
          pages << double(title: 'Example', time: Time.parse('2015-01-20')) # rubocop:todo RSpec/VerifiedDoubles
          pages << double(title: 'Authors', time: Time.parse('2015-01-30')) # rubocop:todo RSpec/VerifiedDoubles
          home2 = double(title: 'Home', time: Time.parse('2014-01-23')) # rubocop:todo RSpec/VerifiedDoubles
          pages << home2
          allow(wiki).to receive(:revisions).and_return pages # rubocop:todo RSpec/SubjectStub
          expect(wiki.revisions_by_title('Home')).to eq [home2, home1]
        end
      end
    end
  end
end
