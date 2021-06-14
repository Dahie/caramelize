# frozen_string_literal: true

require 'spec_helper'

# rubocop:todo RSpec/SpecFilePathFormat
describe Caramelize::Wikka2Markdown do # rubocop:todo RSpec/FilePath, RSpec/SpecFilePathFormat
  # rubocop:enable RSpec/SpecFilePathFormat
  let(:filter) { described_class.new(body) }

  describe '#run' do
    subject { filter.run }

    xcontext 'when keep line breaks' do # rubocop:todo RSpec/PendingWithoutReason
      let(:body) { "line1\nline2" }

      it { is_expected.to eq "line1  \nline2" }
    end

    context 'when headline h1' do
      let(:body) { '======Headline======' }

      it { is_expected.to eq '# Headline' }
    end

    context 'when headline h2' do
      let(:body) { '=====Headline=====' }

      it { is_expected.to eq '## Headline' }
    end

    context 'when headline h3' do
      let(:body) { '====Headline====' }

      it { is_expected.to eq '### Headline' }
    end

    context 'when headline h4' do
      let(:body) { '===Headline===' }

      it { is_expected.to eq '#### Headline' }
    end

    context 'when headline h5' do
      let(:body) { '==Headline==' }

      it { is_expected.to eq '##### Headline' }
    end

    context 'when bold' do
      let(:body) { '**Text is bold**' }

      it { is_expected.to eq '**Text is bold**' }
    end

    context 'when italic' do
      let(:body) { '//Text is italic//' }

      it { is_expected.to eq '*Text is italic*' }
    end

    context 'when underline' do
      let(:body) { '__Text is underlined__' }

      it { is_expected.to eq '<u>Text is underlined</u>' }
    end

    context 'when line break' do
      let(:body) { 'Text is---\nbroken to two lines.' }

      it { is_expected.to eq 'Text is  \nbroken to two lines.' }
    end

    context 'when unordered list entry' do
      context 'with tab based' do
        let(:body) { "\t-unordered list entry" }

        it { is_expected.to eq '- unordered list entry' }
      end

      context 'with tabs' do
        let(:body) { '~-unordered list entry' }

        it { is_expected.to eq '- unordered list entry' }
      end

      context 'with spaces' do
        let(:body) { '    -unordered list entry' }

        it { is_expected.to eq '- unordered list entry' }
      end

      context 'with tab based with space' do
        let(:body) { "\t- unordered list entry" }

        it { is_expected.to eq '- unordered list entry' }
      end

      context 'with another tab based with space' do
        let(:body) { '~- unordered list entry' }

        it { is_expected.to eq '- unordered list entry' }
      end

      context 'with space based with space' do
        let(:body) { '    - unordered list entry' }

        it { is_expected.to eq '- unordered list entry' }
      end
    end

    context 'when ordered list entry' do
      context 'without space' do
        let(:body) { '~1)ordered list entry' }

        it { is_expected.to eq '1. ordered list entry' }
      end

      context 'with space' do
        let(:body) { '~1) ordered list entry' }

        it { is_expected.to eq '1. ordered list entry' }
      end
    end

    context 'when wikilink' do
      context 'with only url' do
        let(:body) { '[[LemmaLemma]]' }

        it { is_expected.to eq '[[LemmaLemma]]' }
      end

      context 'with only url sklfs' do
        let(:body) { "\n        [[ComunitySiteIdeas]]        \n" }

        it { is_expected.to eq "\n        [[ComunitySiteIdeas]]        \n" }
      end

      context 'with url and pipe title' do
        let(:body) { '[[SandBox|Test your formatting skills]]' }

        it { is_expected.to eq '[[Test your formatting skills|SandBox]]' }
      end

      context 'with url and title' do
        let(:body) { '[[SandBox Test your formatting skills]]' }

        it { is_expected.to eq '[[Test your formatting skills|SandBox]]' }
      end
    end

    context 'when hyperlink' do
      context 'with only url' do
        let(:body) { '[[http://target]]' }

        it { is_expected.to eq '<http://target>' }
      end

      context 'with url with title' do
        let(:body) { '[[http://target Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end

      context 'with url with title and special characters' do
        let(:body) { '- [[http://www.sourcepole.com/sources/programming/cpp/cppqref.html C++ Syntax Reference]]' }

        it { is_expected.to eq '- [C++ Syntax Reference](http://www.sourcepole.com/sources/programming/cpp/cppqref.html)' }
      end

      context 'with url with pipe' do
        let(:body) { '[[http://target|Title]]' }

        it { is_expected.to eq '[Title](http://target)' }
      end
    end

    context 'when inline code' do
      let(:body) { 'Code: %%Hello World%% // done' }

      it { is_expected.to eq 'Code: `Hello World` // done' }
    end

    context 'when code block' do
      let(:body) do
        <<~CPP
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

        CPP
      end
      let(:expected_result) do
        <<~CPP
          Text before

          ```
          std::cin >> input;
          ++stat[input];
          ```

          Text after

          ```
          std::cin >> input;
          ++stat[input];
          ```

        CPP
      end

      it { is_expected.to eq expected_result }
    end

    context 'when code block with language' do
      let(:body) do
        <<~CPP
          Text before

          %%(php)
          std::cin >> input;
          ++stat[input];
          %%

          Text after

          %%(java)
          std::cin >> input;
          ++stat[input];
          %%

        CPP
      end
      let(:expected_result) do
        <<~CPP
          Text before

          ```php
          std::cin >> input;
          ++stat[input];
          ```

          Text after

          ```java
          std::cin >> input;
          ++stat[input];
          ```

        CPP
      end

      it { is_expected.to eq expected_result }
    end
  end
end
