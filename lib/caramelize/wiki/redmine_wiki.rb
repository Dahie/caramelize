#Encoding: UTF-8
module Caramelize
  autoload :DatabaseConnector, 'caramelize/database_connector'
  autoload :SwapWikiLinks, 'caramelize/filters/swap_wiki_links'
  
  class RedmineWiki < Wiki
    include DatabaseConnector
    
    def initialize options={}
      super(options)
      @options[:markup] = :textile
      @options[:create_namespace_home] = true unless @options[:create_namespace_home]
      @options[:swap_interwiki_links] = true
      @options[:filters] << Caramelize::SwapWikiLinks.new
    end
    
    # after calling this action, I expect the @titles and @revisions to be filled
    def read_pages
      @revisions = []
      @titles = []
      @latest_revisions = {}

      # get all projects
      results_projects = database.query("SELECT id, identifier, name FROM projects;")
      results_projects.each do |row_project|
        #collect all namespaces
        @namespaces << {:identifier => row_project["identifier"], :name => row_project["name"]}
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
        @titles << title
        
        results_contents.each do |row_content|
          author = @authors[row_content["author_id"]] ? @authors[row_content["author_id"]] : nil
          page = Page.new({:id => row_content["id"],
                            :title => title,
                            :body => row_content["data"],
                            :markup => :textile,
                            :latest => false,
                            :time => row_content["updated_on"],
                            :message => row_content["comments"],
                            :author => author,
                            :author_name => author.name})
          #puts page.body
          @revisions << page
          @latest_revisions[title] = page
        end
      end
      @titles.uniq!
      @latest_revisions.each { |rev| rev[1].set_latest }
      @revisions.sort! { |a,b| a.time <=> b.time }

      # TODO find latest revision for each limit
      
      @revisions
    end
    
    def read_authors
      sql = "SELECT id, login, mail FROM users;"
      @authors = {}
      results = database.query(sql)
      results.each do |row|
        author = Author.new
        author.id    = row["id"]
        author.name  = row["login"]
        author.email = row["mail"]
        @authors[author.id] = author
      end
      @authors
    end
  end
end