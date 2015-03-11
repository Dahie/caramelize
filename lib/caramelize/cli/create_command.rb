require 'caramelize/cli'
require 'fileutils'

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
      # create dummy config file
      target_file = @config_file.nil? ? "caramel.rb" : @config_file
      FileUtils.cp(File.dirname(__FILE__) +"/../caramel.rb", target_file)
      if commandparser.verbosity == :normal
        puts "Created new configuration file: #{target_file}"
      end
    end
  end
end