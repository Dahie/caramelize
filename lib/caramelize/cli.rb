require 'cmdparse'
require 'caramelize/version'

module Caramelize
  autoload :ContentTransferer, 'caramelize/content_transferer'
  module CLI
    
    # Namespace for all classes that act as CLI commands.
    autoload :RunCommand, 'caramelize/cli/run_command'
    autoload :CreateCommand, 'caramelize/cli/create_command'
    
  
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
          opts.on("--config DIR", "-d", String, "The config file (default: caramel.rb)") {|p| @directory = p}
          opts.on("--verbose", "-v", "Print more output") { @verbosity = :verbose }
          opts.on("--quiet", "-q", "No output") { @verbosity = :quiet }
        end
        self.add_command(CmdParse::HelpCommand.new)
        self.add_command(CmdParse::VersionCommand.new)
      end

      KNOWN_CONFIG_LOCATIONS = ['config/caramel.rb', "config/caramel.config", "caramel.rb", "src/caramel.rb"]

      # Finds the configuration file, if it exists in a known location.
      def detect_configuration_file(config_path = nil)
        possible_files = KNOWN_CONFIG_LOCATIONS
        possible_files.detect{|f| File.exists?(f)}
      end
      
      # Utility method for sub-commands to transfer wiki contents
      def transfer_content
        
        time_start = Time.now
        
        file = detect_configuration_file
        if file && File.exists?(file)
          instance_eval(File.read(file), file || '<eval>')
          original_wiki = input_wiki
          
          ContentTransferer.execute original_wiki, {:verbosity => @verbosity}
          
          time_end = Time.now
          
          puts "Time required: #{time_end - time_start} s" if @verbosity
        else
          puts "No config file found."
        end
        
      end

      # :nodoc:
      def parse(argv = ARGV)
        Caramelize::CLI.constants.select {|c| c =~ /.+Command$/ }.each do |c|
          self.add_command(Caramelize::CLI.const_get(c).new, (c.to_s == 'RunCommand' ? false : false)) # set runcommand as default
        end
        super
      end

    end

  end

end