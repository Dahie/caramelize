# frozen_string_literal: true

require 'caramelize/input_wiki/media_wiki'
require 'caramelize/input_wiki/redmine_wiki'
require 'caramelize/input_wiki/wikka_wiki'

## Example caramelize configuration file

# Within this method you can define your own Wiki-Connectors to Wikis
# not supported by default in this software

# Note, if you want to activate this, you need to uncomment the line below.
def customized_wiki
  # This example is a reimplementation of the WikkaWiki-Connector.
  # To connect to WikkaWiki, I suggest to use the predefined Connector below.
  options = { host: 'localhost',
              username: 'user',
              database: 'database_name',
              password: 'Picard-Delta-5',
              markup: :wikka }
  wiki = Caramelize::InputWiki::Wiki.new(options)
  wiki.instance_eval do
    def read_pages
      sql = 'SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;'
      results = database.query(sql)
      results.each do |row|
        titles << row['tag']
        author = @authors[row['user']]
        properties = { id: row['id'],
                       title: row['tag'],
                       body: row['body'],
                       markup: 'wikka',
                       latest: row['latest'] == 'Y',
                       time: row['time'],
                       message: row['note'],
                       author: }
        page = Page.new(properties)
        revisions << page
      end
      titles.uniq!
      revisions
    end
  end

  wiki
end

# if you want to use one of the preset Wiki-Connectors uncomment the connector
# and edit the database logins accordingly.
def predefined_wiki
  # For connection to a WikkaWiki-Database use this Connector
  # options = { host: "localhost",
  #      username: "root",
  #      password: "root",
  #      database: "wikka" }
  # return Caramelize::InputWiki::WikkaWiki.new(options)
  #
  # For connection to a MediaWiki-Database use this Connector
  # By default it converts to markdown
  # options = { host: "localhost",
  #      username: "root",
  #      password: "root",
  #      database: "my_wiki" }
  # return Caramelize::InputWiki::MediaWiki.new(options)

  # For connection to a Redmine-Database use this Connector
  # Additional options:
  # :create_namespace_overview => true/false (Default: true)  -  Creates a new wikipage at /home as root page for Gollum wiki
  options = { host: 'localhost',
              username: 'root',
              password: 'root',
              database: 'redmine_development' }
  Caramelize::InputWiki::RedmineWiki.new(options)
end

def input_wiki
  # comment and uncomment to easily switch between predefined and
  # costumized Wiki-connectors.

  # return customized_wiki

  predefined_wiki
end
