module Caramelize
  class Wiki
    include DatabaseConnector

    attr_accessor :revisions, :wiki_title, :titles, :description, :namespaces, :options

    def initialize options={}
      @options = options
      @options[:filters] = []
      @namespaces = []
    end

    def revisions_by_title(title)
      if titles.index title
        # new array only containing pages by this name sorted by time
        # TODO this is probably bad for renamed pages if supported
        return revisions.reject { |revision| revision.title != title }.sort { |x,y| x.time <=> y.time }
      end
    end

    # return an empty array in case this action was not overridden
    def read_authors
      return []
    end

    def authors
      @authors ||= {}
    end

    def revisions
      @revisions ||= []
    end

    def titles
      @titles ||= []
    end

    def convert_markup?(to_markup)
      markup != to_markup
    end

    def filters
      @options[:filters]
    end

    def latest_revisions
      @latest_revisions = []
      titles.each do |title|
        # pick first revision by descending date
        @latest_revisions << revisions_by_title(title).last
      end
      @latest_revisions
    end

    def markup
      @options[:markup]
    end

  end
end