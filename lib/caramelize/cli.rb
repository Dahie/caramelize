module Caramelize
  module CLI
    
    # Namespace for all classes that act as CLI commands.
    autoload :RunCommand, 'caramelize/cli/run_command'
    autoload :CreateCommand, 'caramelize/cli/create_command'
    autoload :ContentTransferer, 'caramelize/content_transferer'
  
    # This is the command parser class used for handling the webgen command line interface. After
    # creating an instance, the inherited #parse method can be used for parsing the command line
    # arguments and executing the requested command.
    class CommandParser < CmdParse::CommandParser

      # The website directory. Default: the current working directory.
      attr_reader :directory

      # The verbosity level. Default: <tt>:normal</tt>
      attr_reader :verbosity

      # Create a new CommandParser class. T
      def initialize 
        super(true)
        @directory = nil
        @verbosity = :normal

        self.program_name = "caramelize"
        self.program_version = Caramelize::VERSION
        self.options = CmdParse::OptionParserWrapper.new do |opts|
          opts.separator "Global options:"
          opts.on("--config DIR", "-d", String, "The config file (default: caramel.conf)") {|p| @directory = p}
          opts.on("--verbose", "-v", "Print more output") { @verbosity = :verbose }
          opts.on("--quiet", "-q", "No output") { @verbosity = :quiet }
        end
        self.add_command(CmdParse::HelpCommand.new)
        self.add_command(CmdParse::VersionCommand.new)
      end

      # Utility method for sub-commands to create the correct Webgen::Website object.
      def create_config
        if !defined?(@website)
          @config = Webgen::Website.new(@directory) do |config|
            config['logger.mask'] = @log_filter
          end
        end
        @config
      end

      # Utility method for sub-commands to transfer wiki contents
      def transfer_content
        if !defined?(@content_transferer)
          @content_transferer = ContentTransferer.new config
        end
        @content_transferer.execute
      end

      # :nodoc:
      def parse(argv = ARGV)
        Webgen::CLI.constants.select {|c| c =~ /.+Command$/ }.each do |c|
          self.add_command(Webgen::CLI.const_get(c).new, (c.to_s == 'RunCommand' ? true : false))
        end
        super
      end

    end

  end

end