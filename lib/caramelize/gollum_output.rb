require 'caramelize/ext'
module Caramelize
  class GollumOutput

    SUPPORTED_TARGET_MARKUP =
      %i[markdown textile rdoc creole media_wiki org pod re_structured_text ascii_doc]

    # Initialize a new gollum-wiki-repository at the given path.
    def initialize(new_wiki_path)
      # TODO use sanitized name as wiki-repository-title
      @wiki_path = new_wiki_path
      initialize_repository
    end

    def wiki_path
      @wiki_path
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
      options[:markup] = :markdown if !options[:markup] # target markup
      revisions.each_with_index do |page, index|
        # call debug output from outside
        block.call(page, index) if block_given?
        commit_revision(page, options[:markup])
      end
    end

    def commit_namespace_overview(namespaces)
      page = ::Caramelize::Services::PageBuilder.build_namespace_overview(namespaces)
      commit_revision(page, :markdown)
    end

    def supported_markup
      SUPPORTED_TARGET_MARKUP
    end

    def build_commit(page)
      { message: page.commit_message,
        name: page.author_name,
        email: page.author_email,
        authored_date: page.time,
        committed_date: page.time }
    end

    private

    def gollum
      @gollum ||= Gollum::Wiki.new(wiki_path)
    end

    def initialize_repository
      # TODO ask if we should replace existing paths
      Grit::Repo.init(wiki_path) unless File.exists?(wiki_path)
    end



  end
end
