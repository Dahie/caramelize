module Caramelize
  autoload :DatabaseConnector, 'caramelize/database_connector'
  class Wiki
    include DatabaseConnector
    attr_accessor :revisions, :wiki_title, :titles, :description
    
    def initialize options={}
      @options = options
    end
    
    def revisions_by_title title
      if @titles.index title
        # new array only containing pages by this name sorted by time
        # TODO this is probably bad for renamed pages if supported
        return @revisions.reject { |revision| revision.title != title }.sort { |x,y| x.time <=> y.time }
      end
    end
    
    # return an empty array in case this action was not overridden
    def read_authors
      return []
    end
    
    def convert_syntax? to_markup
      @options[:markup] == to_markup
    end
    
    def latest_revisions
      @latest_revisions = []
      for title in @titles
        # pick first revision by descending date
        @latest_revisions << revisions_by_title(title).last
      end
      @latest_revisions
    end
  end
end