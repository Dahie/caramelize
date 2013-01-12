#Encoding: UTF-8

module Caramelize
  class GollumOutput
    
    def supported_markup 
      [:markdown, :textile]
    end
    
    # Initialize a new gollum-wiki-repository at the given path.
    def initialize wiki_path
      # TODO use sanitized name as wiki-repository-title
      repo = Grit::Repo.init(wiki_path) unless File.exists?(wiki_path)
      @gollum = Gollum::Wiki.new(wiki_path)
    end
    
    # Commit the given page into the gollum-wiki-repository.
    # Make sure the target markup is correct before calling this method.
    def commit_revision(page, markup) 
      message = page.message.empty? ? "Edit in page #{page.title}" : page.message
        
      if page.author
        author = page.author
      else
        author = Author.new
        author.name = page.author_name
        author.email = "mail@example.com"
      end
      
      commit = {:message => message,
               :name => author.name,
               :email => author.email,
               :authored_date => page.time,
               :committed_date => page.time
      }
      
      gollum_page = @gollum.page(page.title)
      if gollum_page
        @gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, commit)
      else
        @gollum.write_page(page.title, markup, page.body, commit)
      end
    end
    
    # Commit all revisions of the given history into this gollum-wiki-repository.
    def commit_history(revisions, options={}, &block)
      options[:markup] = :markdown if options[:markup].nil? # target markup
      revisions.each_with_index do |page, index|
        # call debug output from outside
        block.call(page, index) if block_given?
        commit_revision(page, options[:markup])
      end
    end
    
  end
end