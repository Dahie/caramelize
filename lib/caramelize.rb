#!/usr/bin/env ruby

#File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'caramelize' ) )
require 'mysql2'
require 'grit'
require 'gollum'
require 'ext'
require 'author'
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
  
  def self.read_pages sql
    revisions = []
    results = @client.query(sql)
    results.each do |row|
      puts @authors
      #author = @authors.each { |author| author if author.name == row[:user] }
      
      page = Page.new(row) {}
      page.author = @authors[row[:user]]
      revisions << page
    end
    revisions.sort! { |a,b| a.time <=> b.time }
    revisions
  end
  
  def self.read_authors sql
    authors = {}
    results = @client.query(sql)
    results.each do |row|
      author = Author.new
      author.id    = row[:id]
      author.name  = row[:name]
      author.email = row[:email]
      authors[row[:name]] = author
    end
    authors
  end
  
  @authors = read_authors("SELECT * FROM wikka_users;")
  @revisions = read_pages("SELECT * FROM wikka_pages;")
  
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

end