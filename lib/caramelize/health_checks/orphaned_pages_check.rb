# frozen_string_literal: true

module Caramelize
  module HealthChecks
    class OrphanedPagesCheck
      attr_reader :gollum, :all_intra_wiki_paths, :intra_wiki_paths

      def initialize(gollum)
        @gollum = gollum
        @intra_wiki_paths = []
        @all_intra_wiki_paths = []
      end

      def check
        puts "\n # Pages not linked within Wiki:"
        puts page_paths_without_intra_wiki_path.sort.inspect
      end

      private

      def check_page(page) # rubocop:todo Metrics/MethodLength
        0.tap do |available_count|
          page.intra_wiki_links.each do |intra_wiki_path|
            if page_paths.include?(intra_wiki_path)
              available_count += 1
              intra_wiki_paths << intra_wiki_path
            else
              puts "#{intra_wiki_path} expected, but missing"
            end
          end
          puts "#{available_count}/#{intra_wiki_links.count} available"
        end
      end

      def page_paths
        pages.map(&:path).map { |path| path.split('.').first }
      end

      def check_pages
        pages.map do |page|
          check_page(page)
        end
      end

      def pages
        @pages ||= gollum.pages.map do |gollum_page|
          HealthChecks::Page.new(gollum_page)
        end
      end

      def page_paths_without_intra_wiki_path
        page_paths - intra_wiki_paths
      end
    end
  end
end
