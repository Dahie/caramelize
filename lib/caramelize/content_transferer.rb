# frozen_string_literal: true

require 'ruby-progressbar'

module Caramelize
  require 'caramelize/page'
  require 'caramelize/content_transferer'
  require 'caramelize/database_connector'
  require 'caramelize/output_wiki/gollum'
  require 'caramelize/input_wiki/redmine_wiki'
  require 'caramelize/input_wiki/wikkawiki'

  class ContentTransferer
    attr_reader :input_wiki, :options

    DEFAULT_GOLLUM_HOME_TITLE = 'Home'
    DEFAULT_AUTHOR_NAME = 'Caramelize'

    def initialize(input_wiki, options)
      @input_wiki = input_wiki
      @options = options

      options[:default_author] = options.fetch(:default_author, 'Caramelize')
      options[:markup] = target_markup
    end

    def execute
      input_wiki.read_authors

      commit_history

      if verbose?
        puts "From markup: #{input_wiki.markup}"
        puts "To markup: #{target_markup}"
        puts 'Convert latest revisions:'
      end

      migrate_markup_of_latest_revisions

      puts 'Create Namespace Overview' if verbose?
      create_overview_page_of_namespaces if options[:create_namespace_overview]

      rename_home_page
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
      @output_wiki ||= OutputWiki::Gollum.new(options[:target])
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

    def latest_revisions_count
      input_wiki.latest_revisions.count
    end

    def create_overview_page_of_namespaces
      output_wiki.commit_namespace_overview(input_wiki.namespaces)
    end

    def migrate_markup_progress_bar
      @migrate_markup_progress_bar ||=
        ProgressBar.create(title: 'Markup filters',
                           total: latest_revisions_count)
    end

    def commit_history_progress_bar
      @commit_history_progress_bar ||=
        ProgressBar.create(title: 'Revisions',
                           total: revisions_count)
    end

    def migrate_markup_of_latest_revisions
      input_wiki.latest_revisions.each do |revision|
        migrate_markup_of_revision(revision)
      end
    end

    def commit_history
      output_wiki.commit_history(revisions, options) do |page, index|
        if verbose?
          puts "(#{index + 1}/#{revisions_count}) #{page.time} #{page.title}"
        else
          commit_history_progress_bar.increment
        end
      end
    end

    def migrate_markup_of_revision(revision)
      if verbose?
        puts "Filter source: #{revision.title} #{revision.time}"
      else
        migrate_markup_progress_bar.increment
      end

      body_new = filter_processor.run(revision.body)

      return if body_new == revision.body

      # commit as latest page revision
      output_wiki.commit_revision(build_revision_metadata(body_new), options[:markup])
    end

    def build_revision_metadata(body)
      revision.body = body
      revision.author_name = DEFAULT_AUTHOR_NAME
      revision.time = Time.now
      revision.author = nil
      revision.message = "Markup of '#{revision.title}' converted to #{target_markup}"

      revision
    end

    def rename_home_page
      output_wiki.rename_page(options[:home_page_title], DEFAULT_GOLLUM_HOME_TITLE)
    end
  end
end
