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
  require 'caramelize/wiki/wiki'

  # Controller for the content migration
  class ContentTransferer

    class << self

      # Execute the content migration
      def execute(original_wiki, options={})
        @options = options
        @original_wiki = original_wiki

        options[:default_author] = "Caramelize" if !options[:default_author]
        # see if original wiki markup is among any gollum supported markups
        options[:markup] = output_wiki.supported_markup.index(original_wiki.markup) ? original_wiki.markup : :markdown


        # read page revisions from wiki
        # store page revisions
        original_wiki.read_authors

        # setup progressbar
        create_progress_bar("Revisions", revisions.count)

        # commit page revisions to new wiki
        commit_history


        # TODO reorder interwiki links: https://github.com/gollum/gollum/wiki#bracket-tags

        # init list of filters to perform on the latest wiki pages
        initialize_page_filters

        # if wiki needs to convert syntax, do so
        if verbose?
          puts "From markup: #{original_wiki.markup.to_s}"
          puts "To markup: #{markup.to_s}"
        end

        puts "Latest revisions:" if verbose?

        create_progress_bar("Markup filters", original_wiki.latest_revisions.count)
        migrate_markup_on_last_revision
        create_overview_page_of_namespace
      end

      private

      def revisions
        @revisions ||= original_wiki.read_pages
      end

      def filters
        @filters ||= []
      end

      def initialize_page_filters
        filters |= original_wiki.filters
      end

      def create_overview_page_of_namespace
        return unless options[:create_namespace_home]
        output_wiki.create_namespace_overview(original_wiki.namespaces)
      end

      def migrate_markup_on_last_revision


        if original_wiki.convert_markup? markup # is wiki in target markup


        end # end convert_markup?

        original_wiki.latest_revisions.each do |revision|
          migrate_markup_per_revision(revision)
        end
      end

      def commit_history
        output_wiki.commit_history(revisions, options) do |page, index|
          if verbose?
            puts "(#{index+1}/#{revisions.count}) #{page.time} #{page.title}"
          else
            @progress_bar.increment
          end
        end

      end

      def original_wiki
        @original_wiki
      end

      def verbose?
        options[:verbosity] == :verbose
      end

      def markup
        unless @markup
          # see if original wiki markup is among any gollum supported markups
          @markup = output_wiki.supported_markup.index(original_wiki.markup) ? original_wiki.markup : :markdown
        end
        @markup
      end

      def options
        @options
      end

      def output_wiki
        @output_wiki ||= GollumOutput.new('./wiki.git') # TODO make wiki_path an option
      end

      def migrate_markup_per_revision(revision)
        puts "Filter source: #{revision.title} #{revision.time}"  if options[:verbosity] == :verbose
        @progress_bar.increment

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
          body_new = filter.run body_new
        end
        body_new
      end

      def create_progress_bar(title, total)
        @progress_bar = ProgressBar.create(title: title, total: total, format: '%a %B %p%% %t')
      end
    end

  end
end