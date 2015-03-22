require 'spec_helper'

describe Caramelize::RemoveTableTabLineEndings do

  describe :run do
    let(:filter) { Caramelize::RemoveTableTabLineEndings.new }
    context 'table with tabs at unix line-endings' do
      it 'should remove tabs at end of line' do
        body = "cell1\t|cell2\t|\t\t\n"
        expect(filter.run(body)).to eq "cell1\t|cell2\t|\n"
      end
      it 'should remove spaces at end of line' do
        body = "cell1\t|cell2\t|\t    \n"
        expect(filter.run(body)).to eq "cell1\t|cell2\t|\n"
      end
      context 'replace in full file' do
        it 'returns as expected' do
          input_text = File.open(File.join(['spec', 'fixtures', 'markup', 'table-tab-line-endings-input.textile']), 'r').read
          output_text = File.open(File.join(['spec', 'fixtures', 'markup', 'table-tab-line-endings-output.textile']), 'r').read
          expect(filter.run(input_text)).to eq output_text
        end
      end
    end
    context 'table with tabs at windows line-endings' do
      it 'should remove tabs at end of line' do
        body = "cell1\t|cell2\t|\t\t\r\n"
        expect(filter.run(body)).to eq "cell1\t|cell2\t|\n"
      end
      it 'should remove spaces at end of line' do
        body = "cell1\t|cell2\t|\t    \r\n"
        expect(filter.run(body)).to eq "cell1\t|cell2\t|\n"
      end
    end
  end
end
