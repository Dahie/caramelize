require 'caramelize/ext'
module Caramelize
  module OutputWiki
    class Gollum

      attr_reader :wiki_path

      SUPPORTED_TARGET_MARKUP =
        %i[markdown textile rdoc creole media_wiki org pod re_structured_text ascii_doc]

      # Initialize a new gollum-wiki-repository at the given path.
      def initialize(new_wiki_path)
        # TODO use sanitized name as wiki-repository-title
        @wiki_path = new_wiki_path
        initialize_repository
      end

      # Commit the given page into the gollum-wiki-repository.
      # Make sure the target markup is correct before calling this method.
      def commit_revision(page, markup)
        gollum_page = gollum.page(page.title)
        if gollum_page
          gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, build_commit(page))
        else
          gollum.write_page(page.title, markup, page.body, build_commit(page))
        end
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
        commit_revision(build_namespace_overview, :markdown)
      end

      def supported_markup
        SUPPORTED_TARGET_MARKUP
      end

      def build_commit(page)
        {
          message: page.commit_message,
          name: page.author_name,
          email: page.author_email,
          authored_date: page.time,
          committed_date: page.time
        }
      end

      private

      def build_namespace_overview(namespaces)
        ::Caramelize::Services::PageBuilder.build_namespace_overview(namespaces)
      end

      def gollum
        @gollum ||= ::Gollum::Wiki.new(wiki_path)
      end

      def initialize_repository
        return if File.exists?(wiki_path)
        Grit::Repo.init(wiki_path)
      end
    end
  end
end
