#Encoding: UTF-8
#module Caramelize
  class GollumOutput
    
    def initialize wiki_path
      # TODO use sanitized name as wiki-repository-title
      repo = Grit::Repo.init(wiki_path) unless File.exists?(wiki_path)
      @gollum = Gollum::Wiki.new(wiki_path)
    end
    
    def commit_history revisions
      for page in revisions
        #page.title.sub!(/ü/, 'ue')
        puts page.title
        
        #if Gollum::Page.valid_page_name?(page.title)
          
          gollum_page = @gollum.page(page.title)
          message = page.message.empty? ? "Edit in page #{page.title}" : page.message
          commit = {:message => message
                   #:name => 'Tom Preston-Werner'
          }
          if gollum_page
            # TODO update time?
            @gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, commit)
          else
            @gollum.write_page(page.title, :markdown, page.body, commit)
          end
        #end
      end
    end
  end
#end