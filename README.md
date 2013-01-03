# caramelize

Caramelize is a compact and flexible wiki content migration tool. It is intended for easily creating export of otherwise rare supported legacy wikis. With caramelize you can create your own export configurations and transfer your data into a git-based [gollum](gollum)-wiki retaing all your history and the most flexible access to your wiki content.

In the future more import wiki system may be added. For the moment export is supported for [WikkaWiki](wikka) and [Redmine](redmine)-Wiki.

## Usage

### Building

To try it, you require bundler to build it.

    $ gem install bundler

Clone or fork this repository and start building.

    $ git clone git@github.com:Dahie/caramelize.git
    $ gem build caramelize.gemspec
    
Now to build the gem do 

    $ rake build

or

    $ rake install

to install the new gem right to the system.

### Use

    $ caramelize create 

Creates a template configuration file "caramel.rb". This includes documentation on how to use the preset Wiki-connectors and how to write addition customized connectors.

    $ caramelize run 
    
Will execute a wiki migration based on a found configuration file. These are found in predefined paths.

    $ caramelize help
    
Returns help information.

	$ caramelize version
	
Returns version and release information.

### Options

    $ caramelize create --config my_caramel_configuration.rb

Creates an example configuration by the given name.

    $ caramelize run --config my_caramel_configuration.rb

Executes the given configuration.

    $ caramelize --verbose [command]
    $ caramelize -v [command]
    
Displays more verbose output to the command line.

### Configuration recipes

The created caramel.rb configuration contains the settings on how to import the data of the existing wiki and how to convert it into the format required by caramelize to export to gollum.

In the created example configuration, you find the predefined definitions for importing from WikkaWiki and Redmine and and example for a custom import.

Custom import allows you to import data from wikis that are not natively supported by caramelize. Defining your own wiki import requires a bit of knowledge on Ruby and MySQL as you setup the access to your wiki database and need to define how the data is to be transformed. Depending on the database model of the wiki this can be one simple call for all revisions in the database, or it can get more complicated with multiple mysql-calls as the database becomes more complex.

For a custom wiki you need to create a `wiki` instance object, that receives the necessary database creditials.

    wiki = Caramelize::Wiki.new({:host => "localhost", 
                    :username => "user", 
                    :database => "database_name", 
                    :password => 'monkey', 
                    :markup => :wikka})

This example ignores custom markup conversion and assumes WikkaWiki-markup. 

Once the object is established we need to hook in a method that defines how revisions are read from the database and how they are processed.

    wiki.instance_eval do
    	def read_pages
      		sql = "SELECT id, tag, body, time, latest, user, note FROM wikka_pages ORDER BY time;"
      		@revisions, @titles = [], []
      		results = database.query(sql)
      		results.each do |row|
        		@titles << row["tag"]
        		author = @authors[row["user"]]
		        page = Page.new({:id => row["id"],
                            :title =>   row["tag"],
                            :body =>    row["body"],
                            :markup =>  'wikka',
                            :latest =>  row["latest"] == "Y",
                            :time =>    row["time"],
                            :message => row["note"],
                            :author =>  author,
                            :author_name => row["user"]})
       		 @revisions << page
      	end
      # titles is the list of all unique page titles contained in the wiki
      @titles.uniq!
      # revisions is the list of all revisions ordered by date
      @revisions
    end

In the end the `wiki` instance needs the `@titles` and `@revisions` filled.

Some wikis don't have all necessary metadata saved in the revision. In this case additional database queries are necessary. The configuration recipe is pure ruby code, that is included on execution. **This gives you alot of freedom in writing your configuration, but also a lot of power to break things for yourself. Be advised.**


I'm happy to give support on your recipes and I'd also like to extend caramelize with more wiki modules, if you send in your configurations (minus database credentials of course).



## Content migration

### Wiki support

Caramelize comes with direct support for [WikkaWiki](wikka) and [Redmine](redmine)-Wiki.
More custom wikis can be supported by creating a suitable configuration file. Based on these I can easily add more modules for wider support.

Any imported wiki exports into a [gollum](gollum) git-repository. This is a wiki based on a git-archive. This gives you the flexibility of having all wiki pages exported as physical files, while keeping the history and having an easy and wide-supported access using the wiki server gollum features.

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



## Contributing to caramelize
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2013 Daniel Senff. See LICENSE.md for further details.

[wikka]: http://wikkawiki.org/
[gollum]: https://github.com/github/gollum
[redmine]: http://www.redmine.org/
