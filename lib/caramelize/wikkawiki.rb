#Encoding: UTF-8
module Caramelize
  class WikkaWiki < Wiki
    include DatabaseConnector
    include Wikka2MarkdownConverter
    
    def initialize options={}
      @options = options
    end
    
    # after calling this action, I expect the @titles and @revisions to be filled
    def read_pages
      sql = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
      @revisions = []
      @titles = []
      results = database.query(sql)
      results.each do |row|
        @titles << row["tag"]
        author = @authors[row["user"]]
        page = Page.new({:id => row["id"],
                            :title =>   row["tag"],
                            :body =>    row["body"],
                            :syntax =>  'wikka',
                            :latest =>  row["latest"] == "Y",
                            :time =>    row["time"],
                            :message => row["note"],
                            :author =>  author,
                            :author_name => row["user"]})
        @revisions << page
      end
      @titles.uniq!
      #@revisions.sort! { |a,b| a.time <=> b.time }
      
      @revisions
    end
    
    def read_authors
      sql = "SELECT name, email FROM wikka_users;"
      @authors = {}
      results = database.query(sql)
      results.each do |row|
        author = Author.new
        #author.id    = row["id"]
        author.name  = row["name"]
        author.email = row["email"]
        @authors[author.name] = author
      end
      @authors
    end
  end    
end