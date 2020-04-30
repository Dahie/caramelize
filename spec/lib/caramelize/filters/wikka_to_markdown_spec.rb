require 'spec_helper'

describe Caramelize::Wikka2Markdown do
  let(:filter) { described_class.new(body) }

  describe '#run' do
    subject { filter.run }

    xcontext 'keep line breaks' do
      let(:body) { "line1\nline2" }

      it { is_expected.to eq "line1  \nline2" }
    end

    context 'headline h1' do
      let(:body) { '======Headline======' }

      it { is_expected.to eq '# Headline' }
    end

    context 'headline h2' do
      let(:body) { '=====Headline=====' }

      it { is_expected.to eq '## Headline' }
    end

    context 'headline h3' do
      let(:body) { '====Headline===='}

      it { is_expected.to eq '### Headline' }
    end

    context 'headline h4' do
      let(:body) { '===Headline===' }

      it { is_expected.to eq '#### Headline' }
    end

    context 'headline h5' do
      let(:body) { '==Headline==' }

      it { is_expected.to eq '##### Headline' }
    end

    context 'bold' do
      let(:body) { '**Text is bold**' }

      it { is_expected.to eq '**Text is bold**' }
    end

    context 'italic' do
      let(:body) { '//Text is italic//' }

      it { is_expected.to eq '*Text is italic*' }
    end

    context 'underline' do
      let(:body) { '__Text is underlined__' }

      it { is_expected.to eq '<u>Text is underlined</u>' }
    end

    context 'line break' do
      let(:body) { 'Text is---\nbroken to two lines.' }

      it { is_expected.to eq 'Text is  \nbroken to two lines.' }
    end

    context 'unordered list entry' do
      context 'tab based' do
        let(:body) { "\t-unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end

      context 'also tab based' do
        let(:body) { "~-unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end

      context 'space based' do
        let(:body) { "    -unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end

      context 'tab based with space' do
        let(:body) { "\t- unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end

      context 'also tab based with space' do
        let(:body) { "~- unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end

      context 'space based with space' do
        let(:body) { "    - unordered list entry" }

        it { is_expected.to eq '* unordered list entry' }
      end
    end

    context 'ordered list entry' do
      context 'without space' do
        let(:body) { "~1)ordered list entry" }

        it { is_expected.to eq '1. ordered list entry' }
      end

      context 'with space' do
        let(:body) { "~1) ordered list entry" }

        it { is_expected.to eq '1. ordered list entry' }
      end
    end

    context 'wikilink' do
      context 'only url' do
        let(:body) { '[[LemmaLemma]]' }

        it { is_expected.to eq '[[LemmaLemma]]' }
      end

      context 'url and pipe title' do
        let(:body) { '[[SandBox|Test your formatting skills]]' }

        it { is_expected.to eq '[[Test your formatting skills|SandBox]]' }
      end

      context 'url and title' do
        let(:body) { '[[SandBox Test your formatting skills]]' }

        it { is_expected.to eq '[[Test your formatting skills|SandBox]]' }
      end
    end

    context 'hyperlink' do
      context 'only url' do
        let(:body) { '[[http://target]]' }

        it { is_expected.to eq '<http://target>' }
      end

      context 'url with title' do
        let(:body) { '[[http://target Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end

      context 'url with pipe' do
        let(:body) { '[[http://target|Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end
    end

    context 'code block' do
      let(:body) do
        <<-EOS
Text before

%%
std::cin >> input;
++stat[input];
%%

Text after

%%
std::cin >> input;
++stat[input];
%%

        EOS
      end
      let(:expected_result) do
        <<-EOS
Text before

    std::cin >> input;
    ++stat[input];

Text after

    std::cin >> input;
    ++stat[input];

        EOS
      end

      it { is_expected.to eq expected_result }
    end
  end
end
