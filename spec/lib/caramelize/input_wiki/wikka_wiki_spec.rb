# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::InputWiki::WikkaWiki do
  subject(:wiki) { described_class.new }

  describe '#filters' do
    it 'has 3 filters' do
      expect(wiki.filters.count).to be(3)
    end
  end
end
