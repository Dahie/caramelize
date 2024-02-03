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

    context 'with camel case text downcased' do
      let(:body) { 'Hier ein camelCaseExample, bitte [[DankeDanke]]' }

      it 'does not to wiki link' do
        expect(run).to eq 'Hier ein camelCaseExample, bitte [[DankeDanke]]'
      end
    end

    context 'with camel case text at document end' do
      let(:body) { 'Hier ein CamelCaseExample' }

      # NOTE: this is sortof expected behavior - a wiki page should end on a newline in which case this does not happen
      it 'cuts last character' do
        expect(run).to eq 'Hier ein [[CamelCaseExampl]]e'
      end
    end

    context 'with camel case text at document end with newline' do
      let(:body) { "Hier ein CamelCaseExample\n" }

      it 'does wiki link' do
        expect(run).to eq "Hier ein [[CamelCaseExample]]\n"
      end
    end
  end
end
