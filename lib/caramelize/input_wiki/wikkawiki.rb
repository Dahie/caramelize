# frozen_string_literal: true

require 'caramelize/database_connector'
require 'caramelize/filters/wikka_to_markdown'

module Caramelize
  module InputWiki
    class WikkaWiki < Wiki
      include DatabaseConnector

      SQL_PAGES = 'SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;'
      SQL_AUTHORS = 'SELECT name, email FROM wikka_users;'

      def initialize(options = {})
        super(options)
        @options[:markup] = :wikka
        @options[:filters] << Caramelize::Wikka2Markdown
      end

      # after calling this action, titles and @revisions are expected to be filled
      def read_pages
        pages.each do |row|
          titles << row['tag']
          page = Page.new(build_properties(row))
          revisions << page
        end
        titles.uniq!
        # revisions.sort! { |a,b| a.time <=> b.time }

        revisions
      end

      def read_authors
        results = database.query(authors_query)
        results.each do |row|
          authors[row['name']] = double(name: row['name'],
                                        email: row['email'])
        end
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

      def build_properties(row)
        author = authors[row['user']]
        {
          id: row['id'],
          title: row['tag'],
          body: row['body'],
          markup: :wikka,
          latest: row['latest'] == 'Y',
          time: row['time'],
          message: row['note'],
          author:,
          author_name: row['user']
        }
      end
    end
  end
end
