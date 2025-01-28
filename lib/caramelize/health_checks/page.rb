# frozen_string_literal: true

module Caramelize
  module HealthChecks
    class Page
      attr_reader :gollum_page

      def initialize(gollum_page)
        @gollum_page = gollum_page
      end

      def intra_wiki_links
        gollum_page.text_data.scan(/\[\[(.+\|)?(\S+)\]\]/).map do |match|
          link = match[1]
          (filename == path) ? link : [filename, link].join("/")
        end.uniq
      end

      def filename
        path.split("/").first
      end

      def path
        gollum_page.path
      end
    end
  end
end
