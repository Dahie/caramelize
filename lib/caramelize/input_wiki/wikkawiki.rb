require 'caramelize/input_wiki/wiki'
require 'caramelize/database_connector'
require 'caramelize/filters/wikka_to_markdown'

module Caramelize
  module InputWiki
    class WikkaWiki < Wiki
      include DatabaseConnector

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
        #revisions.sort! { |a,b| a.time <=> b.time }

        revisions
      end

      def read_authors
        sql = 'SELECT name, email FROM wikka_users;'
        results = database.query(sql)
        results.each do |row|
          authors[row['name']] = OpenStruct.new(name:  row['name'],
                                                email: row['email'] )
        end
      end

      private

      def pages
        sql = 'SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;'
        @pages ||= database.query(sql)
      end

      def build_properties(row)
        author = authors[row['user']]
        {
          id: row["id"],
          title: row["tag"],
          body: row["body"],
          markup: :wikka,
          latest: row["latest"] == "Y",
          time: row["time"],
          message: row["note"],
          author: author,
          author_name: row["user"]
        }
      end
    end
  end
end
