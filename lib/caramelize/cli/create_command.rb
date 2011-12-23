#Encoding: UTF-8
require 'caramelize/cli'

module Caramelize::CLI

  # The CLI command for creating a caramelize config file.
  class CreateCommand < CmdParse::Command

    # The website config-file. Default: the current working directory.
    attr_reader :config_file

    def initialize #:nodoc:
      super('create', false)
      self.description = "If the verbosity level is set to verbose, the created files are listed."
      self.short_desc = 'Create a default config file for caramelize'
      self.options = CmdParse::OptionParserWrapper.new do |opts|
        opts.separator "Arguments:"
        opts.on("--config <file>", "-f", String, "The config file (default: caramel.rb)") {|p| @config_file = p}
      end
    end

    def usage # :nodoc:
      "Usage: #{commandparser.program_name} [global options] create [options]"
    end

    # Create a caramelize config file.
    def execute(args)
      begin
        
        # create dummy config file
        target_file = @config_file.nil? ? "caramel.rb" : @config_file 
        
        
        #puts args[0]
        require 'fileutils'
        
        FileUtils.cp(File.dirname(__FILE__) +"/../caramel.rb", target_file)
        
      rescue
        #require 'fileutils'
        #FileUtils.rm_rf(args[0])
        raise
      end
      if commandparser.verbosity == :verbose
        puts "Created new configuration file: #{target_file}"
        #puts paths.sort.join("\n")
      end
    end
    
  end
  
end