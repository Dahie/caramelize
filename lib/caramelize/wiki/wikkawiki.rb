module Caramelize
  require 'caramelize/wiki/wiki'
  require 'caramelize/database_connector'
  require 'caramelize/filters/wikka_to_markdown'

  class WikkaWiki < Wiki
    include DatabaseConnector

    def initialize options={}
      super(options)
      @options[:markup] = :wikka
      @options[:swap_interwiki_links] = false
      @options[:filters] << Caramelize::Wikka2Markdown.new
    end

    # after calling this action, I expect the titles and @revisions to be filled
    def read_pages
      sql = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
      results = database.query(sql)
      results.each do |row|
        titles << row["tag"]
        author = authors[row["user"]]
        page = Page.new({:id => row["id"],
                            :title =>   row["tag"],
                            :body =>    row["body"],
                            :markup =>  :wikka,
                            :latest =>  row["latest"] == "Y",
                            :time =>    row["time"],
                            :message => row["note"],
                            :author =>  author,
                            :author_name => row["user"]})
        revisions << page
      end
      titles.uniq!
      #revisions.sort! { |a,b| a.time <=> b.time }

      revisions
    end

    def read_authors
      sql = "SELECT name, email FROM wikka_users;"
      results = database.query(sql)
      results.each do |row|
        authors[row["name"]] = OpenStruct.new(name:  row["name"],
                                              email: row["email"] )
      end
    end
  end
end