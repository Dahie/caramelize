#Encoding: UTF-8
require 'caramelize/cli'

module Caramelize::CLI

  # The CLI command for rendering a webgen website.
  class RunCommand < CmdParse::Command

    # The website config-file. Default: the current working directory.
    attr_reader :config_file

    def initialize # :nodoc:
      super('run', false)
      self.short_desc = 'Run the wiki content transfer based on the given config file'
      self.options = CmdParse::OptionParserWrapper.new do |opts|
        opts.separator "Arguments:"
        #opts.separator opts.summary_indent + "DIR: the directory in which the website should be created"
        opts.on("--config <file>", "-f", String, "The config file (default: caramel.rb)") {|p| @config_file = p}
      end
    end

    def usage # :nodoc:
      "Usage: #{commandparser.program_name} [global options] run [options]"
    end

    # Transfer Wiki contents
    def execute(args)
      commandparser.transfer_content @config_file
    end

  end

end