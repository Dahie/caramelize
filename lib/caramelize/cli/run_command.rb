#Encoding: UTF-8
require 'caramelize/cli'

module Caramelize::CLI

  # The CLI command for rendering a webgen website.
  class RunCommand < CmdParse::Command

    def initialize # :nodoc:
      super('run', false)
      self.short_desc = 'Run the wiki content transfer based on the given config file'
      self.options = CmdParse::OptionParserWrapper.new do |opts|
        opts.separator "Arguments:"
        #opts.separator opts.summary_indent + "DIR: the directory in which the website should be created"
        opts.on("--config DIR", "-d", String, "The config file (default: caramel.rb)") {|p| @directory = p}
      end
    end

    def usage # :nodoc:
      "Usage: #{commandparser.program_name} [global options] run [options]"
    end

    # Transfer Wiki contents
    def execute(args)
      commandparser.transfer_content
    end

  end

end