require 'spec_helper'

describe Caramelize::Wikka2Markdown do

  describe :run do
    let(:filter) { Caramelize::Wikka2Markdown.new }
    context 'headline h1' do
      it 'converts to markdown' do
        body = '======Headline======'
        expect(filter.run(body)).to eq '# Headline'
      end
    end

    context 'headline h2' do
      it 'converts to markdown' do
        body = '=====Headline====='
        expect(filter.run(body)).to eq '## Headline'
      end
    end

    context 'headline h3' do
      it 'converts to markdown' do
        body = '====Headline===='
        expect(filter.run(body)).to eq '### Headline'
      end
    end

    context 'headline h4' do
      it 'converts to markdown' do
        body = '===Headline==='
        expect(filter.run(body)).to eq '#### Headline'
      end
    end

    context 'headline h1' do
      it 'converts to markdown' do
        body = '======Headline======'
        expect(filter.run(body)).to eq '# Headline'
      end
    end

    context 'bold' do
      it 'converts to markdown' do
        body = '**Text is bold**'
        expect(filter.run(body)).to eq '**Text is bold**'
      end
    end

    context 'italic' do
      it 'converts to markdown' do
        body = '//Text is italic//'
        expect(filter.run(body)).to eq '_Text is italic_'
      end
    end

    context 'underline' do
      it 'converts to markdown' do
        body = '__Text is underlined__'
        expect(filter.run(body)).to eq '<u>Text is underlined</u>'
      end
    end

    context 'line break' do
      it 'converts to markdown' do
        body = 'Text is---\nbroken to two lines.'
        expect(filter.run(body)).to eq 'Text is  \nbroken to two lines.'
      end
    end

    context 'unordered list entry' do
      context 'tab based' do
        it 'converts to markdown' do
          body = "\t-unordered list entry"
          expect(filter.run(body)).to eq '*unordered list entry'
        end
      end

      context 'also tab based' do
        it 'converts to markdown' do
          body = "~-unordered list entry"
          expect(filter.run(body)).to eq '*unordered list entry'
        end
      end

      context 'space based' do
        it 'converts to markdown' do
          body = "    -unordered list entry"
          expect(filter.run(body)).to eq '*unordered list entry'
        end
      end
    end

    context 'hyperlink' do
      it 'converts to markdown' do
        body = '[[Title http://target]]'
        expect(filter.run(body)).to eq '[[http://target|Title]]'
      end
    end
  end
end
