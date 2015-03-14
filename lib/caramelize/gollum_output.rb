require 'caramelize/ext'
module Caramelize
  class GollumOutput

    def supported_markup
      [:markdown, :textile]
    end

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

    def create_namespace_overview(namespaces)
      body = "## Overview of namespaces\n\n"
      namespaces.each do |namespace|
        # TODO change wiki as configurable default home
        # TODO support other markup syntaxes
        body << "* [[#{namespace[:name]}|#{namespace[:identifier]}/Wiki]]  \n"
      end
      page = Page.new(title: "Home",
                      body: body,
                      message: 'Create Namespace Overview',
                      latest: true)
      commit_revision(page, :markdown)
      page
    end


    private

    def gollum
      @gollum ||= Gollum::Wiki.new(wiki_path)
    end

    def initialize_repository
      # TODO ask if we should replace existing paths
      Grit::Repo.init(wiki_path) unless File.exists?(wiki_path)
    end

    def build_commit(page)
      message = page.message.empty? ? "Edit in page #{page.title}" : page.message

      { message: message,
        name: page.author_name,
        email: page.author_email,
        authored_date: page.time,
        committed_date: page.time }
    end

  end
end