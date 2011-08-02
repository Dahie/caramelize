#Encoding: UTF-8

module Caramelize
  autoload :Wiki, 'caramelize/wiki'
  autoload :WikkaWiki, 'caramelize/wikkawiki'
  autoload :RedmineWiki, 'caramelize/redmine_wiki'
  autoload :GollumOutput, 'caramelize/gollum_output'
  autoload :Wikka2MarkdownConverter, 'wikka2markdown_converter'
  autoload :Author, 'caramelize/author'
  autoload :Page, 'caramelize/page'
  
  
  class ContentTransferer
    
    def initialize
      
    end
    
    def execute
      
      time_start = Time.now
  
      # establich connection to wiki
      
      # TODO outsource to config
      
      #original_wiki = WikkaWiki.new(:host => "localhost", :username => "root", :database => "wikka")
      #original_wiki = RedmineWiki.new(:host => "localhost", :username => "root", :database => "redmine_development")
      
      original_wiki = WikkaWiki.new(:host => "db2.variomedia.de", :username => "u16283", :database => "db16283", :password => 'SNnYhn363v')
      #original_wiki = RedmineWiki.new(:host => "db4.variomedia.de", :username => "u22507", :database => "db22507", :password => 'crepped67')
      
      
      # read page revisions from wiki
      # store page revisions
      
      @authors = original_wiki.read_authors
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
      
      
      time_end = Time.now
      
      puts "Time required: #{time_end - time_start} s" 
      
    end
  end
  
end