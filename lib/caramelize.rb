#!/usr/bin/env ruby

File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'mysql2'
require 'grit'
require 'gollum'
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

revisions = read_pages("SELECT * FROM wikka_pages;")

wiki = Wiki.new(revisions)

lemma = wiki.revisions_by_title "dahie"
for page in lemma
  puts page.time
end

# initiate new wiki

def init_wiki repo_name
  # TODO use sanitized name as wiki-repository-title
  repo = Grit::Repo.init(repo_name) unless File.exists?(repo_name)
  new_wiki = Gollum::Wiki.new(repo_name)
  new_wiki  
end

gollum = init_wiki "wiki.git"

# commit page revisions to new wiki

for page in wiki.revisions
  puts page.title if page.latest?
  commit = {:message => page.message,
           #:name => 'Tom Preston-Werner'
  }
  gollum_page = gollum.page(page.title)
  if gollum_page
    # TODO update time?
    gollum.update_page(gollum_page, gollum_page.name, gollum_page.format, page.body, commit)
  else
    gollum.write_page(page.title, :markdown, page.body, commit)
  end
end

# take latest revisions

# parse syntax

# convert to new syntax

# commit as latest page revision

