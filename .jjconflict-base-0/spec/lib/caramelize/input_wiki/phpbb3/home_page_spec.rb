require 'spec_helper'

describe Caramelize::InputWiki::Phpbb3::HomePage do
  let(:forums) { []}
  let(:topics) { []}
  let(:posts) { []}
  let(:users) { []}
  let(:input_wiki) do
    double(forums: forums, topics: topics, posts: posts)
  end
  subject(:home_page) { described_class.new(input_wiki) }

  describe '#body' do
    context 'no forums' do
      let(:expected_body) { "# Home\n\n" }

      it { expect(home_page.body).to eq(expected_body) }
    end

    context 'with 1 forum' do
      let(:forum) { { 'forum_name' => 'Forum 1', 'forum_id' => 1 } }
      let(:forums) { [forum] }

      context 'and no topics' do
        let(:expected_body) { "# Home\n\n## Forum 1\n\n\n" }

        it { expect(home_page.body).to eq(expected_body) }
      end

      context 'and 1 topic' do
        let(:topic1) do
          { 'forum_id' => 1,
            'topic_title' => 'Topic 1',
            'topic_time' => 1036352499,
            'topic_approved' => 1 }
        end
        let(:topics) { [topic1] }
        let(:expected_body) { "# Home\n\n## Forum 1\n\n* [2002-11-03 20:41:39 +0100 - Topic 1](Forum 1/2002/11/Topic 1)\n\n" }

        it { expect(home_page.body).to eq(expected_body) }
      end
    end
  end
end