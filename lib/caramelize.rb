#!/usr/bin/env ruby

#File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'caramelize' ) )
require 'grit'
require 'gollum'
require 'optparse'
require 'cmdparse'

require 'ext'
require 'database_connector'


module Caramelize  
  
  autoload :CommandParser, 'caramelize/cli'
  
  CommandParser.new
end