require 'caramelize/input_wiki/wiki'
require 'caramelize/filters/swap_wiki_links'
require 'caramelize/filters/remove_table_tab_line_endings'

module Caramelize
  module InputWiki
    class RedmineWiki < Wiki
      include DatabaseConnector

      def initialize(options = {})
        super(options)
        @options[:markup] = :textile
        @options[:filters] << Caramelize::SwapWikiLinks
        @options[:filters] << Caramelize::RemoveTableTabLineEndings
        @options[:create_namespace_overview] = true
      end

      # after calling this action, I expect the titles and revisions to be filled
      def read_pages
        add_projects_as_namespaces

        pages.each do |row_page|
          build_page(row_page)
        end
        titles.uniq!
        @latest_revisions.each { |rev| rev[1].set_latest }
        revisions.sort! { |a,b| a.time <=> b.time }

        # TODO find latest revision for each limit

        revisions
      end

      def read_authors
        results = database.query(authors_query)
        results.each do |row|
          authors[row["id"]] = OpenStruct.new(id: row["id"],
                                              name: row["login"],
                                              email: row["mail"])
        end
        authors
      end

      private

      def build_page(row_page)
        results_contents = database.query(single_page_query(row_page['id']))

        wiki = wikis.select{ |row| row['id'] == row_page['wiki_id'] }.first

        project_identifier = ''

        if wiki
          project = projects.select{ |row| row['id'] == wiki['project_id'] }.first
          project_identifier = project['identifier'] + '/'
        end

        title = project_identifier + row_page['title']
        titles << title

        @latest_revisions = {}
        results_contents.each do |row_content|
          page = Page.new(build_properties(title, row_content))
          revisions << page
          @latest_revisions[title] = page
        end
      end

      def add_projects_as_namespaces
        projects.each do |row_project|
          namespace = OpenStruct.new(identifier: row_project['identifier'],
                                     name: row_project['name'])
          namespaces << namespace
        end
      end

      def authors_query
        'SELECT id, login, mail FROM users;'
      end

      def single_page_query(page_id)
        "SELECT * FROM wiki_content_versions WHERE page_id='#{page_id}' ORDER BY updated_on;"
      end

      def projects_query
        'SELECT id, identifier, name FROM projects;'
      end

      def pages_query
        'SELECT id, title, wiki_id FROM wiki_pages;'
      end

      def wikis_query
        'SELECT id, project_id FROM wikis;'
      end

      def pages
        @pages ||= database.query(pages_query)
      end

      def projects
        @projects ||= database.query(projects_query)
      end

      def wikis
        @wikis ||= database.query(wikis_query)
      end

      def build_properties(title, row_content)
        author = authors.fetch(row_content["author_id"], nil)
        {
          id: row_content['id'],
          title: title,
          body: row_content['data'],
          markup: :textile,
          latest: false,
          time: row_content['updated_on'],
          message: row_content['comments'],
          author: author,
          author_name: author.name
        }
      end
    end
  end
end
