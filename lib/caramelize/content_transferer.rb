#Encoding: UTF-8

require 'gollum'
require 'grit'

module Caramelize
  autoload :Wiki, 'caramelize/wiki/wiki'
  autoload :WikkaWiki, 'caramelize/wiki/wikkawiki'
  autoload :RedmineWiki, 'caramelize/wiki/redmine_wiki'
  autoload :GollumOutput, 'caramelize/gollum_output'
  autoload :Author, 'caramelize/author'
  autoload :Page, 'caramelize/page'
  
  # Controller for the content migration
  class ContentTransferer
    
    # Execute the content migration
    def self.execute(original_wiki, options={})
      
      options[:markup] = :markdown            if !options[:markup]
      options[:default_author] = "Caramelize" if !options[:default_author]
      
      # read page revisions from wiki
      # store page revisions
      
      original_wiki.read_authors
      @revisions = original_wiki.read_pages
      
      # initiate new wiki
      output_wiki = GollumOutput.new('wiki.git') # TODO make wiki_path an option
      
      # commit page revisions to new wiki
      output_wiki.commit_history @revisions, options
      
      # if wiki needs to convert syntax, do so
      if original_wiki.convert_syntax? options[:markup]
        puts "latest revisions:" if options[:verbosity] == :verbose
        # take each latest revision
        for rev in original_wiki.latest_revisions
          puts "Updated syntax: #{rev.title} #{rev.time}"  if options[:verbosity] == :verbose
          
          # parse markup & convert to new syntax
          if options[:markup] == :markdown
            body_new = original_wiki.to_markdown rev.body
          else
            body_new = original_wiki.to_textile rev.body
          end
            
          unless body_new == rev.body
            rev.body = body_new
            rev.author_name = options[:markup]
            rev.time = Time.now
            rev.author = nil
            
            # commit as latest page revision
            output_wiki.commit_revision rev, options
          end
        end  
      end
    end # end execute
  end
end