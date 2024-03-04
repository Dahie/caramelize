# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::MediawikiToMarkdown do
  let(:filter) { described_class.new(body) }

  describe '#run' do
    subject { filter.run }

    # the conversions are performed through pandoc-ruby.
    # This is a smoke test to see if it's called at all,
    # but not testing every single option.

    context 'when headline h1' do
      let(:body) { "= Headline =\n" }

      it { is_expected.to eq "# Headline\n" }
    end

    context 'when headline h2' do
      let(:body) { "== Headline ==\n" }

      it { is_expected.to eq "## Headline\n" }
    end
  end
end
