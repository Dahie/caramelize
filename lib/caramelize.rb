#!/usr/bin/env ruby

#File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'caramelize' ) )
require 'mysql2'
require 'grit'
require 'gollum'
require "page"
require "wiki"
require "gollumoutput"

module Caramelize  
  
  # establich connection to wiki
  socket = ["/tmp/mysqld.sock", 
    "/tmp/mysql.sock", 
    "/var/run/mysqld/mysqld.sock",
    "/opt/local/var/run/mysql5/mysqld.sock",
    "/var/lib/mysql/mysql.sock"].detect{|socket| File.exist?(socket)  }
  @client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "wikka", :socket => socket)
  
  # TODO outsource to config
  
  
  
  
  # read page revisions from wiki
  # store page revisions
  
  def read_pages sql
    revisions = []
    results = @client.query(sql)
    results.each do |row|
      page = Page.new(row) {}
      revisions << page
    end
    revisions
  end
  
  revisions = read_pages("SELECT * FROM wikka_pages;")
  
  wiki = Wiki.new(revisions)
  
  #lemma = wiki.revisions_by_title "dahie"
  #for page in lemma
  #  puts page.time
  #end
  
  # initiate new wiki
  
  output_wiki = GollumOutput.new('wiki.git')
  
  # commit page revisions to new wiki
  
  output_wiki.commit_history revisions
  
  # take latest revisions
  
  # parse syntax
  
  # convert to new syntax
  
  # commit as latest page revision

end