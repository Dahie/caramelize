# frozen_string_literal: true

module Caramelize
  class HealthCheck
    attr_reader :wiki_path, :options

    DEFAULT_GOLLUM_HOME_TITLE = 'Home'

    def initialize(wiki_path, options = {})
      @wiki_path = wiki_path
      @options = options
    end

    def execute
      # puts page_paths.sort.inspect

      check_pages

      # puts intra_wiki_paths.sort.inspect

      puts "\n # Pages not linked within Wiki:"
      puts page_paths_without_intra_wiki_path.sort.inspect
    end

    private

    def files
      @files ||= Dir.glob([wiki_path, '**/*.md'].join('/'))
    end

    def file_names
      files.map do |file|
        file.gsub("#{wiki_path}/", '').split('.').first
      end
    end

    def check_pages
      pages.each do |page|
        puts "\n## #{page.path}"
        check_page(page)
      end
    end

    def check_page(page)
      intra_wiki_links = intra_wiki_links(page.text_data)
      available = 0
      intra_wiki_links.each do |link|
        intra_wiki_link = page.path.split('/').first == page.path ? link : [page.path.split('/').first, link].join('/')
        if page_paths.include?(intra_wiki_link)
          available += 1
          intra_wiki_paths << intra_wiki_link
        else
          puts "#{intra_wiki_link} expected, but missing"
        end
      end
      puts "#{available}/#{intra_wiki_links.count} available"
    end

    def intra_wiki_links(body)
      body.scan(/\[\[(.+\|)?(\S+)\]\]/).map { |match| match[1] }.uniq
    end

    def pages
      gollum.pages
    end

    def page_paths
      pages.map(&:path).map { |path| path.split('.').first }
    end

    def intra_wiki_paths
      @intra_wiki_paths ||= []
    end

    def page_paths_without_intra_wiki_path
      page_paths - intra_wiki_paths
    end

    def check_home_page
      puts 'Home.md missing' if File.exist?('wiki-export/Home.md')
    end

    def gollum
      @gollum ||= ::Gollum::Wiki.new(wiki_path)
    end
  end
end
