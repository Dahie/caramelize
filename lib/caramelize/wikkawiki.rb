#Encoding: UTF-8
module Caramelize
  class WikkaWiki
    include DatabaseConnector
    
    def initialize options={}
      @options = options
    end
    
    def read_pages
      sql = "SELECT * FROM wikka_pages;"
      revisions = []
      results = database.query(sql)
      results.each do |row|
        page = Page.new({:id => row_content["id"],
                            :title => row["tag"],
                            :body => row["body"],
                            :syntax => 'wikka',
                            :latest => row["latest"] == "Y",
                            :time => row["time"],
                            :message => row["note"]})
        page.author = @authors[row[:user]]
        revisions << page
      end
      revisions.sort! { |a,b| a.time <=> b.time }
      revisions
    end
    
    def read_authors
      sql = "SELECT id, name, email FROM wikka_users;"
      @authors = {}
      results = database.query(sql)
      results.each do |row|
        author = Author.new
        #author.id    = row["id"]
        #author.name  = row["name"]
        #author.email = row["email"]
        @authors[author.name] = author
      end
      @authors
    end
  end    
end