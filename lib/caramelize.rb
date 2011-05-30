#!/usr/bin/env ruby

File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'mysql2'
require_relative "caramelize/page"
require_relative "caramelize/wiki"


  

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


revisions = read_pages("SELECT * FROM wikka_pages;") do |page|

  # TODO user
end

wiki = Wiki.new(revisions)
for page in wiki.revisions
  puts page.title if page.latest?
end

# initiate new wiki



# commit page revisions to new wiki

# take latest revisions

# parse syntax

# convert to new syntax

# commit as latest page revision

