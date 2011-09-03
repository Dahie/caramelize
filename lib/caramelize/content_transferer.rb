#Encoding: UTF-8

require 'gollum'
require 'grit'

module Caramelize
  autoload :Wiki, 'caramelize/wiki'
  autoload :WikkaWiki, 'caramelize/wikkawiki'
  autoload :RedmineWiki, 'caramelize/redmine_wiki'
  autoload :GollumOutput, 'caramelize/gollum_output'
  autoload :Wikka2MarkdownConverter, 'wikka2markdown_converter'
  autoload :Author, 'caramelize/author'
  autoload :Page, 'caramelize/page'
  
  
  class ContentTransferer
    
    def self.execute original_wiki, options={}
      
      # read page revisions from wiki
      # store page revisions
      
      original_wiki.read_authors
      @revisions = original_wiki.read_pages
      
      # initiate new wiki
      
      output_wiki = GollumOutput.new('wiki.git')
      
      # commit page revisions to new wiki
      
      output_wiki.commit_history @revisions
      
      # 
      
      if original_wiki.convert_syntax?
        puts "latest revisions:"
        # take each latest revision
        for rev in original_wiki.latest_revisions
          puts "Updated syntax: #{rev.title} #{rev.time}"
          # parse syntax
          # convert to new syntax
          body_new = original_wiki.convert2markdown rev.body
          unless body_new == rev.body
            rev.body = body_new
            rev.author_name = "Caramelize"
            rev.time = Time.now
            rev.author = nil
            
            # commit as latest page revision
            output_wiki.commit_revision rev  
          end
        end  
      end
      
      
      #lemma = wiki.revisions_by_title "dahie"
      #for page in lemma
      #  puts page.time
      #end
      
    end
  end
  
end