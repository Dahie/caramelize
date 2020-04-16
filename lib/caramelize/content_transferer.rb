require 'gollum-lib'
require 'ruby-progressbar'

module Caramelize

  require 'caramelize/page'
  require 'caramelize/content_transferer'
  require 'caramelize/database_connector'
  require 'caramelize/output_wiki/gollum'
  require 'caramelize/input_wiki/redmine_wiki'
  require 'caramelize/input_wiki/wikkawiki'

  class ContentTransferer
    attr_reader :input_wiki, :options, :filter_processor

    def initialize(input_wiki, options)
      @input_wiki = input_wiki
      @options = options

      options[:default_author] = options.fetch(:default_author, "Caramelize")
      options[:target_directory] = 'wiki-export'
      options[:markup] = target_markup
    end

    def execute
      input_wiki.read_authors

      commit_history

      if verbose?
        puts "From markup: #{input_wiki.markup.to_s}"
        puts "To markup: #{target_markup.to_s}"
        puts "Convert latest revisions:"
      end

      migrate_markup_of_latest_revisions

      puts 'Create Namespace Overview' if verbose?
      create_overview_page_of_namespaces if options[:create_namespace_overview]
    end

    private

    def target_markup
      @target_markup ||=
        needs_conversion_to_target_markup? ? input_wiki.markup : :markdown
    end

    def needs_conversion_to_target_markup?
      output_wiki.supported_markup.index(input_wiki.markup)
    end

    def revisions
      @revisions ||= input_wiki.read_pages
    end

    def output_wiki
      @output_wiki ||= OutputWiki::Gollum.new(options[:target_directory])
    end

    def filter_processor
      @filter_processor ||= FilterProcessor.new(input_wiki)
    end

    def verbose?
      options[:verbose]
    end

    def revisions_count
      revisions.count
    end

    def create_overview_page_of_namespaces
      output_wiki.commit_namespace_overview(input_wiki.namespaces)
    end

    def migrate_markup_of_latest_revisions
      progress_bar = ProgressBar.create(title: "Markup filters",
                                        total: revisions_count)

      input_wiki.latest_revisions.each do |revision|
        migrate_markup_of_revision(revision, progress_bar)
      end
    end

    def commit_history
      progress_bar = ProgressBar.create(title: "Revisions",
                                        total: revisions_count)

      output_wiki.commit_history(revisions, options) do |page, index|
        if verbose?
          puts "(#{index + 1}/#{revisions_count}) #{page.time} #{page.title}"
        else
          progress_bar.increment
        end
      end
    end

    def migrate_markup_of_revision(revision, progress_bar)
      if verbose?
        puts "Filter source: #{revision.title} #{revision.time}"
      else
        progress_bar.increment
      end

      body_new = filter_processor.run(revision.body)

      unless body_new == revision.body
        revision.body = body_new
        revision.author_name = target_markup
        revision.time = Time.now
        revision.author = nil

        # commit as latest page revision
        output_wiki.commit_revision(revision, options[:markup])
      end
    end
  end
end
