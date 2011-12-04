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
    def commit_revision(page,options={}) 
      options[:markup] = :markdown if options[:markup].nil? 
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
        # OPTIMIZE support not just markdown
        @gollum.write_page(page.title, options[:markup], page.body, commit)
      end
    end
    
    # Commit all revisions of the given history into this gollum-wiki-repository.
    def commit_history(revisions, options={})
      revisions.each_with_index do |page, index|
        puts "(#{index+1}/#{revisions.count}) #{page.time}  #{page.title}" if options[:verbosity] == :verbose
        
        commit_revision(page, options)
      end
    end
    
  end
end