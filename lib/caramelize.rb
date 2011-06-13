#!/usr/bin/env ruby

#File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'caramelize' ) )
require 'mysql2'
require 'grit'
require 'gollum'

require 'ext'
require 'database_connector'
require "wiki"
require 'wikkawiki'
require 'redmine_wiki'
require 'author'
require "page"

require "gollumoutput"

module Caramelize  
  
  time_start = Time.now
  
  # establich connection to wiki
  
  # TODO outsource to config
  
  original_wiki = WikkaWiki.new(:host => "localhost", :username => "root", :database => "wikka")
  #original_wiki = RedmineWiki.new(:host => "localhost", :username => "root", :database => "redmine_development")
  
  
  # read page revisions from wiki
  # store page revisions
  
  @authors = original_wiki.read_authors
  @revisions = original_wiki.read_pages
  
  #lemma = wiki.revisions_by_title "dahie"
  #for page in lemma
  #  puts page.time
  #end
  
  # initiate new wiki
  
  output_wiki = GollumOutput.new('wiki.git')
  
  # commit page revisions to new wiki
  
  output_wiki.commit_history @revisions
  
  # take latest revisions
  
  # parse syntax
  
  # convert to new syntax
  
  # commit as latest page revision
  
  time_end = Time.now
  
  puts "Time required: #{time_end - time_start} s"

end