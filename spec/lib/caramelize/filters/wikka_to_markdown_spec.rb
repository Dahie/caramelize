require 'spec_helper'

describe Caramelize::Wikka2Markdown do

  describe '#run' do
    let(:filter) { described_class.new }
    subject { filter.run(body) }

    context 'headline h1' do
      let(:body) { '======Headline======' }

      it { is_expected.to eq '# Headline' }
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
      let(:body) { '//Text is italic//' }

      it { is_expected.to eq '*Text is italic*' }
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

    context 'wikilink' do
      context 'only url' do
        let(:body) { '[[LemmaLemma]]' }

        it { is_expected.to eq '[[LemmaLemma]]' }
      end

      context 'url and title' do
        let(:body) { '[[SandBox|Test your formatting skills]]' }

        it { is_expected.to eq '[[SandBox|Test your formatting skills]]' }
      end
    end

    context 'hyperlink' do
      context 'only url' do
        let(:body) { '[[http://target]]' }

        it { is_expected.to eq '<http://target>' }
      end

      context 'url with space' do
        let(:body) { '[[http://target Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end

      context 'url with pipe' do
        let(:body) { '[[http://target|Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end
    end
  end
end
