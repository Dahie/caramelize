require 'gollum-lib'

module Caramelize
  module OutputWiki
    class Gollum

      attr_reader :wiki_path

      SUPPORTED_TARGET_MARKUP =
        %i[markdown textile rdoc creole media_wiki org pod re_structured_text ascii_doc].freeze

      # Initialize a new gollum-wiki-repository at the given path.
      def initialize(new_wiki_path)
        # TODO use sanitized name as wiki-repository-title
        @wiki_path = new_wiki_path
        initialize_repository
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

      def rename_page(page_title, rename)
        gollum_page = gollum.page(page_title)
        gollum.rename_page(gollum_page, rename, { message: 'Rename home page' })
      end

      # Commit all revisions of the given history into this gollum-wiki-repository.
      def commit_history(revisions, options = {}, &block)
        revisions.each_with_index do |page, index|
          # call debug output from outside
          block.call(page, index) if block_given?
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
          name: page.author.name,
          email: page.author.email,
          time: page.time
        }
      end

      private

      def build_namespace_overview(namespaces)
        ::Caramelize::Services::PageBuilder.build_namespace_overview(namespaces)
      end

      def gollum
        @gollum ||= ::Gollum::Wiki.new(wiki_path, {repo_is_bare: true})
      end

      def initialize_repository
        return if File.exists?(wiki_path)
        Dir.mkdir(wiki_path)
        #::Gollum::Git::Repo.new(wiki_path, { is_bare: true })
        ::Gollum::Git::Repo.init(wiki_path)
      end
    end
  end
end
