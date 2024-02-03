# frozen_string_literal: true

module Caramelize
  module InputWiki
    class Wiki
      include DatabaseConnector

      attr_accessor :revisions, :wiki_title, :titles, :description, :namespaces, :options

      def initialize(options = {})
        @options = options
        @options[:filters] = []
        @namespaces = []
      end

      def revisions_by_title(title)
        # new array only containing pages by this name sorted by time asc
        # this does not support renamed pages
        revisions.select { |revision| revision.title == title }
                 .sort { |x, y| x.time <=> y.time }
      end

      # return an empty array in case this action was not overridden
      def read_authors
        []
      end

      def namespaces
        @namespaces ||= {}
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

      def excluded_pages
        []
      end

      def convert_markup?(to_markup)
        markup != to_markup
      end

      def filters
        @options[:filters]
      end

      def latest_revisions
        @latest_revisions ||= titles.map { |title| revisions_by_title(title).last }.compact
      end

      def markup
        @options[:markup]
      end
    end
  end
end
