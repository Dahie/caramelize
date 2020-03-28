require 'gollum-lib'
require 'grit'
require 'ruby-progressbar'

module Caramelize
  class FilterProcessor
    attr_reader :filters, :input_wiki

    def initialize(input_wiki)
      @filters = []
      @input_wiki = input_wiki

      initialize_wiki_filters
    end

    def run(body)
      body_new = body
      filters.each do |filter|
        body_new = filter.run(body_new)
      end
      body_new
    end

    private

    def initialize_wiki_filters
      filters << input_wiki.filters
      filters.flatten!
    end
  end
end
