#Encoding: UTF-8

require 'caramelize/cli'

module Caramelize::CLI

  # The CLI command for rendering a webgen website.
  class RunCommand < CmdParse::Command

    def initialize # :nodoc:
      super('run', false)
      self.short_desc = 'Run the wiki content transfer based on the given config file'
    end

    # Transfer Wiki contents
    def execute(args)
      commandparser.transfer_content
    end

  end

end