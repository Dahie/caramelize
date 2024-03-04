# frozen_string_literal: true

require 'gollum-lib'

module Caramelize
  module OutputWiki
    class Gollum
      attr_reader :wiki_path

      SUPPORTED_TARGET_MARKUP =
        %i[markdown textile rdoc creole media_wiki org pod re_structured_text ascii_doc].freeze

      # Initialize a new gollum-wiki-repository at the given path.
      def initialize(new_wiki_path)
        # TODO: use sanitized name as wiki-repository-title
        @wiki_path = new_wiki_path
        initialize_repository unless File.exist?(wiki_path)
      end

      # Commit the given page into the gollum-wiki-repository.
      # Make sure the target markup is correct before calling this method.
      def commit_revision(page, markup)
        gollum_page = gollum.page(page.path)

        if gollum_page
          gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, build_commit(page))
        else
          gollum.write_page(page.path, markup, page.body, build_commit(page))
        end
      end

      def rename_page(page_title, new_title)
        gollum_page = gollum.page(page_title)
        gollum.rename_page(gollum_page, new_title, { message: 'Rename home page' })
      end

      # Commit all revisions of the given history into this gollum-wiki-repository.
      def commit_history(revisions, options = {}, &block)
        revisions.each_with_index do |page, index|
          # call debug output from outside
          yield(page, index) if block
          commit_revision(page, options.fetch(:markup, :markdown))
        end
      end

      def commit_namespace_overview(namespaces)
        commit_revision(build_namespace_overview(namespaces), :markdown)
      end

      def supported_markup
        SUPPORTED_TARGET_MARKUP
      end

      def build_commit(page)
        {
          message: page.commit_message,
          name: page.author_name,
          email: page.author_email,
          time: page.time
        }
      end

      private

      def build_namespace_overview(namespaces)
        ::Caramelize::Services::PageBuilder.build_namespace_overview(namespaces)
      end

      def gollum
        @gollum ||= ::Gollum::Wiki.new(wiki_path, { repo_is_bare: true, ref: 'main' })
      end

      def initialize_repository
        Dir.mkdir(wiki_path)
        # ::Gollum::Git::Repo.new(wiki_path, { is_bare: true })
        ::Gollum::Git::Repo.init(wiki_path)
      end
    end
  end
end
