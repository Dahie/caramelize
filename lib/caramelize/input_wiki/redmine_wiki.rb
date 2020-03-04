require 'caramelize/input_wiki/wiki'
require 'caramelize/filters/swap_wiki_links'
require 'caramelize/filters/remove_table_tab_line_endings'

module Caramelize
  module InputWiki
    class RedmineWiki < Wiki
      include DatabaseConnector

      def initialize options={}
        super(options)
        @options[:markup] = :textile
        @options[:filters] << Caramelize::SwapWikiLinks.new
        @options[:filters] << Caramelize::RemoveTableTabLineEndings.new
        @options[:create_namespace_overview] = true
      end

      # after calling this action, I expect the titles and revisions to be filled
      def read_pages
        # get all projects
        results_projects = database.query("SELECT id, identifier, name FROM projects;")
        results_projects.each do |row_project|
          #collect all namespaces
          namespaces << OpenStruct.new(identifier: row_project["identifier"], name: row_project["name"])
        end

        # get all wikis
        results_wikis = database.query("SELECT id, project_id FROM wikis;")

        # get all lemmas
        results_pages = database.query("SELECT id, title, wiki_id FROM wiki_pages;")
        results_pages.each do |row_page|
          results_contents = database.query("SELECT * FROM wiki_content_versions WHERE page_id='#{row_page["id"]}' ORDER BY updated_on;")

          # get wiki for page
          wiki_row = nil
          project_row = nil
          results_wikis.each do |wiki|
            wiki_row = wiki if wiki["id"] == row_page["wiki_id"]
          end

          if wiki_row
            # get project from wiki-id
            results_projects.each do |project|
              project_row = project if project["id"] == wiki_row["project_id"]
            end
          end

          project_identifier = project_row ? project_row["identifier"] + '/' : ""

          title = project_identifier + row_page["title"]
          titles << title

          @latest_revisions = {}
          results_contents.each do |row_content|
            page = Page.new(build_properties)
            revisions << page
            @latest_revisions[title] = page
          end
        end
        titles.uniq!
        @latest_revisions.each { |rev| rev[1].set_latest }
        revisions.sort! { |a,b| a.time <=> b.time }

        # TODO find latest revision for each limit

        revisions
      end

      def read_authors
        results = database.query("SELECT id, login, mail FROM users;")
        results.each do |row|
          authors[row["id"]] = OpenStruct.new(id: row["id"],
                                              name: row["login"],
                                              email: row["mail"])
        end
        authors
      end

      private

      def build_properties(row)
        author = authors[row_content["author_id"]] ? @authors[row_content["author_id"]] : nil
        { id: row_content["id"],
          title: title,
          body: row_content["data"],
          markup: :textile,
          latest: false,
          time: row_content["updated_on"],
          message: row_content["comments"],
          author: author,
          author_name: author.name
        }
      end
    end
  end
end