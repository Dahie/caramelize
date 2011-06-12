module Caramelize
  class Page
  
    attr_accessor :title, :body, :id, :syntax, :latest, :time, :message
  
    def initialize page
      @id =      page["id"]
      @title =   page["tag"]
      @body =    page["body"]
      @syntax =  "WikkaWiki"
      @latest =  page["latest"] == "Y"
      @time =    page["time"]
      @message = page["note"]
      yield 
    end
    
    def latest?
      @latest
    end
    
    def to_s
      @title
    end
  end
end