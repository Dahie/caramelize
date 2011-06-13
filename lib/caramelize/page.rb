module Caramelize
  class Page
  
    attr_accessor :title, :body, :id, :syntax, :latest, :time, :message, :author, :author_name
  
    def initialize page={}
      @id =      page[:id]
      @title =   page[:title]
      @body =    page[:body]
      @syntax =  page[:syntax]
      @latest =  page[:latest]
      @time =    page[:time]
      @message = page[:message]
      @author =  page[:author]
      @author_name =  page[:author_name]
    end
    
    def latest?
      @latest
    end
    
    def set_latest
      @latest = true
    end
    
    def to_s
      @title
    end
  end
end