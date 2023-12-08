# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::RemoveTableTabLineEndings do
  subject(:run) { filter.run }

  let(:filter) { described_class.new(body) }

  describe '#run' do
    context 'table with tabs at unix line-endings' do
      let(:body) { "cell1\t|cell2\t|\t\t\n" }

      it 'removes tabs at end of line' do
        expect(run).to eq "cell1\t|cell2\t|\n"
      end
    end

    context 'with spaces on line ending' do
      let(:body) { "cell1\t|cell2\t|\t    \n" }

      it 'removes spaces at end of line' do
        expect(run).to eq "cell1\t|cell2\t|\n"
      end

      context 'replace in full file' do
        let(:body) do
          File.read(File.join(['spec', 'fixtures', 'markup', 'table-tab-line-endings-input.textile']))
        end

        it 'returns as expected' do
          output_text = File.read(File.join(['spec', 'fixtures', 'markup', 'table-tab-line-endings-output.textile']))
          expect(run).to eq output_text
        end
      end
    end

    context 'with table having tabs at windows line-endings' do
      let(:body) { "cell1\t|cell2\t|\t\t\r\n" }

      it 'removes tabs at end of line' do
        expect(run).to eq "cell1\t|cell2\t|\n"
      end
    end

    context 'with spaces and windows line-endings' do
      let(:body) { "cell1\t|cell2\t|\t    \r\n" }

      it 'removes spaces at end of line' do
        expect(run).to eq "cell1\t|cell2\t|\n"
      end
    end
  end
end
