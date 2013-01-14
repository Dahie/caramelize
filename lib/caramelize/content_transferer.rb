#Encoding: UTF-8

require 'gollum'
require 'grit'
require 'ruby-progressbar'

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
      options[:default_author] = "Caramelize" if !options[:default_author]

      # read page revisions from wiki
      # store page revisions
      original_wiki.read_authors
      @revisions = original_wiki.read_pages
      # initiate new wiki
      output_wiki = GollumOutput.new('wiki.git') # TODO make wiki_path an option
      
      if !options[:markup]
        # see if original wiki markup is among any gollum supported markups
        options[:markup] = output_wiki.supported_markup.index(original_wiki.markup) ? original_wiki.markup : :markdown
      end
      puts  options[:markup]

      # setup progressbar
      progress_revisions = ProgressBar.create(:title => "Revisions", :total => @revisions.count, :format => '%a %B %p%% %t')

      # TODO ask if we should replace existing paths

      # commit page revisions to new wiki
      output_wiki.commit_history(@revisions, options) do |page, index|
        if options[:verbosity] == :verbose
          puts "(#{index+1}/#{@revisions.count}) #{page.time} #{page.title}"
        else
          progress_revisions.increment
        end
      end

      # if wiki needs to convert syntax, do so
      puts "From markup: " + original_wiki.markup.to_s if options[:verbosity] == :verbose
      puts "To markup: " + options[:markup].to_s if options[:verbosity] == :verbose
      if original_wiki.convert_markup? options[:markup] # is wiki in target markup
        
        #setup progress for markup conversion
        progress_markup = ProgressBar.create(:title => "Markup", :total => original_wiki.latest_revisions.count, :format => '%a %B %p%% %t')

        puts "Latest revisions:" if options[:verbosity] == :verbose
        # take each latest revision
        for rev in original_wiki.latest_revisions
          puts "Updated syntax: #{rev.title} #{rev.time}"  if options[:verbosity] == :verbose
          progress_markup.increment
          
          # parse markup & convert to new syntax
          if options[:markup] == :markdown
            body_new = original_wiki.to_markdown rev.body
          else
            body_new = original_wiki.to_textile rev.body
          end

          unless body_new.eql? rev.body
            rev.body = body_new
            rev.author_name = options[:markup]
            rev.time = Time.now
            rev.author = nil
            
            # commit as latest page revision
            output_wiki.commit_revision rev, options[:markup]
          end
        end
      end
    end # end execute
  end
end