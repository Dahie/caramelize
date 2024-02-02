# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::CamelCaseToWikiLinks do
  describe '#run' do
    subject(:run) { filter.run }

    let(:filter) { described_class.new(body) }

    context 'with camel case text' do
      let(:body) { 'Hier ein CamelCaseExample, bitte [[DankeDanke]]' }

      it 'does wiki link' do
        expect(run).to eq 'Hier ein [[CamelCaseExample]], bitte [[DankeDanke]]'
      end
    end

    context 'with camel case text' do
      let(:body) { 'Hier ein camelCaseExample, bitte [[DankeDanke]]' }

      it 'does not to wiki link' do
        expect(run).to eq 'Hier ein camelCaseExample, bitte [[DankeDanke]]'
      end
    end
  end
end
