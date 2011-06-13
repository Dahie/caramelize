module Caramelize
  class Wiki
    
    attr_accessor :revisions, :wiki_title, :titles, :description
    
    #def initialize revisions
    #  @revisions = revisions
    #end
    
    def revisions_by_title title
      if @titles[title]
        # new array only containing pages by this name sorted by time
        # TODO this is probably bad for renamed pages if supported
        return @revisions.reject { |revision| revision.title != title }.sort { |x,y| x.time <=> y.time }
      end
    end
    
    def latest_revisions
      
      @revisions
    end
  end
end