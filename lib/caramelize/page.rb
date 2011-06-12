module Caramelize
  class Page
  
    attr_accessor :title, :body, :id, :syntax, :latest, :time, :message, :author
  
    def initialize page={}
      @id =      page[:id]
      @title =   page[:title]
      @body =    page[:body]
      @syntax =  page[:syntax]
      @latest =  page[:latest]
      @time =    page[:time]
      @message = page[:message]
    end
    
    def latest?
      @latest
    end
    
    def to_s
      @title
    end
  end
end