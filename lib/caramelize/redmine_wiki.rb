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
      results_pages.each do |row_page|
        results_contents = database.query("SELECT * FROM wiki_content_versions WHERE page_id='#{row_page["id"]}';")
        results_contents.each do |row_content|
          author = @authors[row_content["author_id"]] ? @authors[row_content["author_id"]] : nil
          page = Page.new({:id => row_content["id"],
                            :title => row_page["title"],
                            :body => row_content["data"],
                            :syntax => 'textile',
                            :latest => false,
                            :time => row_content["updated_on"],
                            :message => row_content["comments"],
                            :author => author,
                            :author_name => author.name})
          revisions << page
        end
      end
      revisions.sort! { |a,b| a.time <=> b.time }
      
      # TODO find latest revision for each limit
      
      revisions
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