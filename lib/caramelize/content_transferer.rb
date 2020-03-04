require 'gollum-lib'
require 'grit'
require 'ruby-progressbar'

module Caramelize

  require 'caramelize/page'
  require 'caramelize/ext'
  require 'caramelize/content_transferer'
  require 'caramelize/database_connector'
  require 'caramelize/gollum_output'
  require 'caramelize/wiki/redmine_wiki'
  require 'caramelize/wiki/wikkawiki'

  # Controller for the content migration
  class ContentTransferer

    class << self

      # Execute the content migration
      def execute(input_wiki, options={})
        @input_wiki = input_wiki
        @options = options

        options[:default_author] = "Caramelize" unless options[:default_author]
        # see if original wiki markup is among any gollum supported markups
        options[:markup] = target_markup

        input_wiki.read_authors
        initialize_page_filters
        commit_history

        # if wiki needs to convert syntax, do so
        if verbose?
          puts "From markup: #{input_wiki.markup.to_s}"
          puts "To markup: #{markup.to_s}"
        end

        puts "Latest revisions:" if verbose?

        migrate_markup_on_last_revision
        create_overview_page_of_namespaces if options[:create_namespace_overview]
      end

      private

      def target_markup
        needs_conversion_to_target_markup? ? input_wiki.markup : :markdown
      end

      def needs_conversion_to_target_markup?
        output_wiki.supported_markup.index(input_wiki.markup)
      end

      def revisions
        @revisions ||= input_wiki.read_pages
      end

      def filters
        @filters ||= []
      end

      def initialize_page_filters
        filters << input_wiki.filters
        filters.flatten!
      end

      def create_overview_page_of_namespaces
        puts 'Create Namespace Overview' if verbose?
        output_wiki.commit_namespace_overview(input_wiki.namespaces)
      end

      def migrate_markup_on_last_revision
        if input_wiki.convert_markup? markup # is wiki in target markup
          # TODO
        end # end convert_markup?

        create_progress_bar("Markup filters", input_wiki.latest_revisions.count) unless verbose?
        input_wiki.latest_revisions.each do |revision|
          migrate_markup_per_revision(revision)
        end
      end

      def commit_history
        # setup progressbar
        create_progress_bar("Revisions", revisions.count) unless verbose?
        output_wiki.commit_history(revisions, options) do |page, index|
          if verbose?
            puts "(#{index+1}/#{revisions.count}) #{page.time} #{page.title}"
          else
            @progress_bar.increment
          end
        end
      end

      def input_wiki
        @input_wiki
      end

      def verbose?
        options[:verbosity] == :verbose
      end

      def markup
        unless @markup
          # see if original wiki markup is among any gollum supported markups
          @markup = output_wiki.supported_markup.index(input_wiki.markup) ? input_wiki.markup : :markdown
        end
        @markup
      end

      def options
        @options
      end

      def output_wiki
        @output_wiki ||= GollumOutput.new('./wiki-export') # TODO make wiki_path an option
      end

      def migrate_markup_per_revision(revision)
        if verbose?
          puts "Filter source: #{revision.title} #{revision.time}"
        else
          @progress_bar.increment
        end

        # run filters
        body_new = run_filters(revision.body)

        unless body_new == revision.body
          revision.body = body_new
          revision.author_name = markup
          revision.time = Time.now
          revision.author = nil

          # commit as latest page revision
          output_wiki.commit_revision revision, options[:markup]
        end

      end

      def run_filters(body)
        body_new = body
        filters.each do |filter|
          body_new = filter.run(body_new)
        end
        body_new
      end

      def create_progress_bar(title, total)
        @progress_bar = ProgressBar.create(title: title, total: total, format: '%a %B %p%% %t')
      end
    end
  end
end
