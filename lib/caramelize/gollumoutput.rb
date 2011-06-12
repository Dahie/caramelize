#Encoding: UTF-8
module Caramelize
  class GollumOutput
    
    def initialize wiki_path
      # TODO use sanitized name as wiki-repository-title
      repo = Grit::Repo.init(wiki_path) unless File.exists?(wiki_path)
      @gollum = Gollum::Wiki.new(wiki_path)
    end
    
    def commit_history revisions
      revisions.each_with_index do |page, index|
        puts "(#{index+1}/#{revisions.count}) #{page.time}  #{page.title}" 
        
        gollum_page = @gollum.page(page.title)
        message = page.message.empty? ? "Edit in page #{page.title}" : page.message
        commit = {:message => message,
                 :name => page.author.name,
                 :email => page.author.email,
                 :authored_date => page.time,
                 :committed_date => page.time
        }
        if gollum_page
          @gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, commit)
        else
          @gollum.write_page(page.title, :markdown, page.body, commit)
        end
      end
    end
  end
end