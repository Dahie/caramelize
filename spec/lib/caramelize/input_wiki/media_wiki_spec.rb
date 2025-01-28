# frozen_string_literal: true

require "spec_helper"

describe Caramelize::InputWiki::MediaWiki do
  subject(:wiki) { described_class.new }

  describe "#filters" do
    it "has 2 filters" do
      expect(wiki.filters.count).to be(2)
    end
  end
end
