# frozen_string_literal: true

require 'caramelize/filters/add_newline_to_page_end'

module Caramelize
  module InputWiki
    class MediaWiki < Wiki
      include DatabaseConnector

      # for Mediawiki v1.41
      SQL_PAGES = %{
        SELECT *
        FROM revision as r
        JOIN page as p on r.rev_page = p.page_id
        JOIN comment as c ON c.comment_id = r.rev_comment_id
        JOIN actor as a ON a.actor_id = r.rev_actor
        JOIN slots as s ON s.slot_revision_id = r.rev_id
        JOIN content as cn ON cn.`content_id` = s.slot_content_id
        JOIN text as t ON cn.content_address = CONCAT('tt:', t.old_id)
        ORDER BY r.rev_timestamp ASC;
      }
      SQL_AUTHORS = 'SELECT user_id, user_name, user_real_name, user_email FROM user;'
      NAMESPACE_MAPPING = {
        0 => :NS_MAIN,
        1 => :NS_TALK,
        2 => :NS_USER,
        3 => :NS_USER_TALK,
        4 => :NS_PROJECT,
        5 => :NS_PROJECT_TALK,
        6 => :NS_FILE,
        7 => :NS_FILE_TALK,
        8 => :NS_MEDIAWIKI,
        9 => :NS_MEDIAWIKI_TALK,
        10 => :NS_TEMPLATE,
        11 => :NS_TEMPLATE_TALK,
        12 => :NS_HELP,
        13 => :NS_HELP_TALK,
        14 => :NS_CATEGORY,
        15 => :NS_CATEGORY_TALK
      }.freeze

      def initialize(options = {})
        super(options)
        @options[:markup] = :mediawiki
        @options[:filters] << Caramelize::AddNewlineToPageEnd
      end

      # after calling this action, titles and @revisions are expected to be filled
      def read_pages
        pages.each do |row|
          titles << row['page_title']
          revisions << Page.new(build_properties(row))
        end
        titles.uniq!
        revisions
      end

      def read_authors
        database.query(authors_query).each do |row|
          puts row.inspect
          name = row['user_real_name'].empty? ? row['user_name'] : 'Anonymous'
          email = row['user_email'].empty? ? nil : row['user_email']
          authors[row['user_id']] = { name:, email: }
        end

        authors
      end

      def excluded_pages
        []
      end

      private

      def pages_query
        SQL_PAGES
      end

      def authors_query
        SQL_AUTHORS
      end

      def pages
        @pages ||= database.query(pages_query)
      end

      def build_properties(row) # rubocop:todo Metrics/MethodLength
        author = authors[row['actor_user']] || { name: 'Anonymous', email: 'anonymous@example.com' }
        {
          id: row['rev_id'],
          title: title_by_namespace(row),
          body: row['old_text'],
          markup: :mediawiki,
          latest: row['page_latest'] == row['rev_id'],
          time: Time.strptime(row['rev_timestamp'], '%Y%m%d%H%M%S'),
          message: row['comment_text'],
          author:
        }
      end

      def title_by_namespace(row)
        return row['page_title'] if namespace_matches?(row['page_namespace'], :NS_MAIN)
        return "#{row['page_title']}_Discussion" if namespace_matches?(row['page_namespace'], :NS_TALK)

        row['page_title']
      end

      def namespace_matches?(namespace_id, expected_namespace)
        NAMESPACE_MAPPING[namespace_id] == expected_namespace
      end
    end
  end
end
