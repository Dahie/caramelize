# frozen_string_literal: true

require "caramelize/filters/add_newline_to_page_end"
require "caramelize/filters/camel_case_to_wiki_links"
require "caramelize/filters/wikka_to_markdown"

module Caramelize
  module InputWiki
    class WikkaWiki < Wiki
      include DatabaseConnector

      SQL_PAGES = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
      SQL_AUTHORS = "SELECT name, email FROM wikka_users;"
      FUNCTION_PAGES = %w[AdminBadWords AdminPages AdminUsers AdminSpamLog CategoryAdmin CategoryCategory CategoryWiki DatabaseInfo FormattingRules HighScores InterWiki MyChanges MyPages OrphanedPages OwnedPages PageIndex PasswordForgotten RecentChanges RecentlyCommented Sandbox SysInfo TableMarkup TableMarkupReference TextSearch TextSearchExpanded UserSettings WantedPages WikiCategory WikkaInstaller WikkaConfig WikkaDocumentation WikkaMenulets WikkaReleaseNotes].freeze

      def initialize(options = {})
        super
        @options[:markup] = :wikka
        @options[:filters] << ::Caramelize::AddNewlineToPageEnd
        @options[:filters] << ::Caramelize::WikkaToMarkdown
        @options[:filters] << ::Caramelize::CamelCaseToWikiLinks
      end

      # after calling this action, titles and @revisions are expected to be filled
      def read_pages
        pages.each do |row|
          titles << row["tag"]
          revisions << Page.new(build_properties(row))
        end
        titles.uniq!
        revisions
      end

      def read_authors
        results = database.query(authors_query)
        results.each do |row|
          authors[row["name"]] = {name: row["name"], email: row["email"]}
        end
      end

      def excluded_pages
        FUNCTION_PAGES
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
        author = authors[row["user"]]
        {
          id: row["id"],
          title: row["tag"],
          body: row["body"],
          markup: :wikka,
          latest: row["latest"] == "Y",
          time: row["time"],
          message: row["note"],
          author:
        }
      end
    end
  end
end
