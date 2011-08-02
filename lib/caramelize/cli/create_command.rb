#Encoding: UTF-8

require 'webgen/cli'
require 'webgen/websitemanager'

module Caramelize::CLI

  # The CLI command for creating a caramelize config file.
  class CreateCommand < CmdParse::Command

    def initialize #:nodoc:
      super('create', false)
      self.description = Utils.format("If the verbosity level is set to verbose, the created files are listed.")
      self.short_desc = 'Create a default config file for caramelize'
      self.options = CmdParse::OptionParserWrapper.new do |opts|
        opts.separator "Arguments:"
        opts.separator opts.summary_indent + "DIR: the directory in which the website should be created"
      end
    end

    def usage # :nodoc:
      "Usage: #{commandparser.program_name} [global options] create [options] DIR"
    end

    # Create a caramelize config file in the directory <tt>args[0]</tt>.
    def execute(args)
      if args.length == 0
        raise OptionParser::MissingArgument.new('DIR')
      else
        begin
          
          # TODO create dummy config file
          
        rescue
          require 'fileutils'
          FileUtils.rm_rf(args[0])
          raise
        end
        if commandparser.verbosity == :verbose
          puts "The following files were created in the directory #{args[0]}:"
          #puts paths.sort.join("\n")
        end
      end
    end
    
  end
  
end