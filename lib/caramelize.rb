#!/usr/bin/env ruby

#File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'caramelize' ) )
require 'mysql2'
require 'grit'
require 'gollum'
require 'ext'
require 'database_connector'
require 'wikkawiki'
require 'redmine_wiki'
require 'author'
require "page"
require "wiki"
require "gollumoutput"

module Caramelize  
  
  time_start = Time.now
  
  # establich connection to wiki
  
  
  # TODO outsource to config
  
  
  
  
  # read page revisions from wiki
  # store page revisions
  #original_wiki = WikkaWiki.new(:host => "localhost", :username => "root", :database => "wikka")
  original_wiki = RedmineWiki.new(:host => "localhost", :username => "root", :database => "redmine_development")
  @authors = original_wiki.read_authors
  @revisions = original_wiki.read_pages
  
  wiki = Caramelize::Wiki.new(@revisions)
  
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