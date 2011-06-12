#Encoding: UTF-8
module Caramelize
  class RedmineWiki
    include DatabaseConnector
    
    def initialize options={}
      @options = options
    end
    
    def read_pages
      sql = "SELECT id, title FROM wiki_pages;"
      revisions = []
      results_pages = database.query(sql)
      results_pages.each do |row|
        page_id = row["id"]
        results_contents = database.query("SELECT * FROM wiki_content_versions WHERE page_id='#{page_id}';")
        results_contents.each do |row_content|
          puts row_content["updated_on"]
          page = Page.new({:id => row_content["id"],
                            :title => row["title"],
                            :body => row_content["data"],
                            :syntax => 'textile',
                            :latest => false,
                            :time => row_content["updated_on"],
                            :message => row_content["comments"]})
          
          page.author = @authors[row["author_id"]]
          revisions << page
          
        end
        
        
      end
      revisions.sort! { |a,b| a.time <=> b.time }
      
      # find latest revision for each limit
      
      revisions
    end
    
    def read_authors
      sql = "SELECT id, login, mail FROM users;"
      @authors = {}
      results = database.query(sql)
      results.each do |row|
        author = Author.new
        #author.id    = row["id"]
        #author.name  = row["login"]
        #author.email = row["mail"]
        @authors[author.id] = author
      end
      @authors
    end
  end    
end