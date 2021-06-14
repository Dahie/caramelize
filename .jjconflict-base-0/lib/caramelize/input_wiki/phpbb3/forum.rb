require 'caramelize/input_wiki/wiki'
require 'caramelize/filters/bbcode_to_markdown'

module Caramelize
  module InputWiki
    module Phpbb3
    class Forum < Wiki
      include DatabaseConnector

      SQL_FORUMS = 'SELECT forum_id, forum_name, forum_desc FROM phpbb_forums;'
      SQL_POSTS = 'SELECT * FROM phpbb_posts ORDER BY post_time ASC;'
      SQL_TOPICS = 'SELECT topic_id, topic_title, topic_poster, topic_time, forum_id, topic_approved FROM phpbb_topics;'
      SQL_USERS = 'SELECT user_id, username, user_email FROM phpbb_users;'

      def initialize(options = {})
        super(options)
        @options[:markup] = :bbcode # https://wiki.phpbb.com/Help:Formatting
        @options[:create_namespace_overview] = false
        @options[:filters] << Caramelize::BbcodeToMarkdown
      end

      def read_pages
        posts.each do |post|
          topic = topics.select { |t| t['topic_id'] == post['topic_id'] }.first
          forum = forums.select { |f| f['forum_id'] == post['forum_id'] }.first
          time = format_time(topic['topic_time'])
          title = [forum['forum_name'],
                   time.year,
                   time.month,
                   parameterice(topic['topic_title'])].join('/')

          unless titles.include?(title)
            titles << title
            topic_pages[title] = ''
          end

          topic_pages[title] += new_post_body(post)

          page = Page.new(build_properties(title, post))
          revisions << page
        end

        create_home_page

        revisions
      end

      def forums
        @forums ||= database.query(SQL_FORUMS)
      end

      def topics
        @topics ||= database.query(SQL_TOPICS)
      end

      def posts
        @posts ||= database.query(SQL_POSTS)
      end

      def users
        @users ||= database.query(SQL_USERS)
      end

      def topic_pages
        @topic_pages ||= {}
      end

      def read_authors
        users.each do |row|
          authors[row['user_id']] = build_author(row)
        end
        authors
      end

      private

      def create_home_page
        revisions << HomePage.new(self)
      end

      def parameterice(string)
        string.gsub(/[\[\]']/, '-')
      end

      def new_post_body(post)
        author = authors.dig(post['poster_id'])
        author_name = author_name(post, author)

        "## #{post['post_subject']}\n" \
          "*By **#{author_name}** on #{format_time(post['post_time'])}*\n\n" +
          post['post_text'] + "\n\n"
      end

      def build_author(row)
        email = row['user_email'] == '' ? 'mail@example.com' : row['user_email']
        OpenStruct.new(id: row['user_id'],
                       name: row['username'],
                       email: email)
      end

      def author_name(post, author)
        author_name = author&.name
        useful_username = post['poster_id'] == 1 && !post['post_username'].empty?
        author_name = post['post_username'] if useful_username
        author_name
      end

      def build_properties(title, post)
        author = authors.dig(post['poster_id'])
        author_name = author_name(post, author)
        {
          id: post['post_id'],
          title: title,
          body: topic_pages[title],
          markup: :phpbb,
          latest: false,
          time: format_time(post['post_time']),
          message: build_message(title, author_name),
          author: author,
          author_name: author_name
        }
      end

      def build_message(title, author_name)
        "#{author_name} added post to '#{title}'"
      end

      def format_time(time)
        Time.at(time)
      end
    end
  end
end
end