# Caramelize

[![Maintainability](https://api.codeclimate.com/v1/badges/7fe3ef34e09ba8133424/maintainability)](https://codeclimate.com/github/Dahie/caramelize/maintainability)

Caramelize is a compact and flexible wiki migration tool. It is intended for easy transfer of content from legacy wikis. With caramelize you can create your own export configurations and migrate your page revisions into a git repository of markdown files. This retains all your history and you gain the most flexible access to your wiki content available for use with git-based wikis like [gollum](https://github.com/github/gollum), [Otter Wiki](https://github.com/redimp/otterwiki), [Wiki.js](https://js.wiki/) or [Obsidian](https://obsidian.md/).

By default, it ships with configurations for [WikkaWiki](http://wikkawiki.org/) and [Redmine](http://www.redmine.org/).


## Usage

### Installation

```sh
$ gem install caramelize
```

Install the latest release of caramelize using RubyGems.
Requires pandoc to be installed.

### Use

```sh
$ caramelize create
```

Creates a template configuration file "caramel.rb". This includes documentation on how to use the preset Wiki-connectors and how to write addition customized connectors. More about this below.

```sh
$ caramelize run
```

Will start the wiki migration based on the configuration file. These are either found in predefined paths (./caramel.rb, ./config.rb, …), or passed as argument, as below.

```sh
$ caramelize doctor
```

Can be used to assess the quality of your wiki conversion. It'll help you see
how many wiki links may be broken and how many pages were orphaned.

```sh
$ caramelize help
```

Returns help information.

```sh
$ caramelize version
```

Returns version and release information.

### Options

```sh
$ caramelize create --config my_caramel_configuration.rb
```

Creates an example configuration by the given name.

```sh
$ caramelize run --config my_caramel_configuration.rb
```

Executes the given configuration.

```sh
$ caramelize --verbose [command]
```

Displays more verbose output to the command line.

## Content migration

### Wiki support

Caramelize comes with direct support for [MediaWiki](https://www.mediawiki.org), [WikkaWiki](http://wikkawiki.org/) and [Redmine](http://www.redmine.org/)-Wiki.
More custom wikis can be supported by creating a suitable configuration file.

The wiki is exported to markdown files in a git-repository. This can be directly used as source for [gollum](https://github.com/github/gollum) wiki, [Otter Wiki](https://github.com/redimp/otterwiki), or if you don't care about the history even [Obsidian](https://obsidian.md/). 
This gives you the flexibility of having all wiki pages exported as physical files, while keeping the history and having an easy and wide-supported way of access.

Since wiki software may have special features, that are not common among other wikis, content migration may always have a loss of style or information. Caramelize tries to support the most common features.

* Page meta data
  * title
  * content body
  * author name
  * author email address
  * date
  * revisions
* Markup conversion to markdown
  * limited to "simple" formatting, excluding complex formats such as tables
  * conversion using regular expressions -> somewhat easy to learn and extend

### Configuration recipes

The `lib/caramelize/caramel.rb` configuration contains the settings on how to import the data of the existing wiki and how to convert it into the format required by caramelize to export to gollum.
You also find the predefined definitions for importing from WikkaWiki and Redmine and and example for a custom import.

Custom import allows you to import data from wikis that are not natively supported by caramelize. Defining your own wiki import requires a bit of knowledge on Ruby and MySQL as you setup the access to your wiki database and need to define how the data is to be transformed. Depending on the database model of the wiki this can be one simple call for all revisions in the database, or it can get more complicated with multiple mysql-calls as the database becomes more complex.

For a custom wiki you need to create a `wiki` instance object, that receives the necessary database creditials.

```ruby
wiki = Caramelize::InputWiki::Wiki.new(host: "localhost",
                                    username: "user",
                                    database: "database_name",
                                    password: 'monkey',
                                    markup: :wikka})
```

This example ignores custom markup conversion and assumes WikkaWiki-markup.

Once the object is established we need to hook in a method that defines how revisions are read from the database and how they are processed.

```ruby
wiki.instance_eval do
    def read_pages
        sql = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
        revisions, titles = [], []
        results = database.query(sql)
        results.each do |row|
            titles << row["tag"]
            author = authors[row["user"]]
            page = Page.new({id: row["id"],
                        title:   row["tag"],
                        body:    row["body"],
                        markup:  'wikka',
                        latest:  row["latest"] == "Y",
                        time:    row["time"],
                        message: row["note"],
                        author:  author})
            revisions << page
    end
    # titles is the list of all unique page titles contained in the wiki
    titles.uniq!
    # revisions is the list of all revisions ordered by date
    revisions
end
```

In the end the `wiki` instance needs the `titles` and `revisions` filled.

Some wikis don't have all necessary metadata saved in the revision. In this case additional database queries are necessary. **The configuration recipe is pure ruby code, that is included on execution. This gives you a lot of freedom in writing your configuration, but also a lot of power to break things. Be advised.**

I'm happy to give support on your recipes and I'd also like to extend caramelize with more wiki modules, if you send in your configurations (minus database credentials of course).

### Building

This is how you can build caramelize, in case you'd like to develop it further. To get startered you'll need Bundler.

```sh
$ gem install bundler
```

Clone or fork this repository and start building.

```sh
$ git clone git@github.com:Dahie/caramelize.git
$ gem build caramelize.gemspec
```

Now to build and package the gem do

```sh
$ rake build
```

or

```sh
$ rake install
```

to install the new gem right to your system.

Tests run with

```sh
$ rspec
```

## Contributing to caramelize

* Check out the latest main to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2024 Daniel Senff. See LICENSE.md for further details.
