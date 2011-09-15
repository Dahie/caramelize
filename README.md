# caramelize

Caramelize is a compact and flexible wiki converter. It is intended for easily creating export of otherwise rare supported legacy wikis. With caramelize you can create your own export configurations and transfer your data into a git-based gollum-wiki retaing all your history.

In the future more target wiki system may be added. For the moment export is supported for WikkaWiki and Redmine-Wiki.

## Usage

### Building

For the moment caramelize is not yet stable and not released to any gemsites.

To try it you require bundler to build it.

    $ gem bundler install

Clone this repository and start building.

    $ git clone git@github.com:Dahie/caramelize.git
    $ gem build caramelize.gemspec
    
Now to build the gem do 

    $ rake build

or

    $ rake install

to install the new gem right to the system.

### Use

    $ caramelize create <directory> 

Creates a template configuration file. This includes documentation on how to use the preset Wiki-connectors and how to write addition customized connectors.


    $ caramelize run 
    
Will execute a wiki migration based on a found configuration file. These are found in predefined paths.

    $ caramelize help
Returns help information.

	$ caramelize version
Returns version and release information.

## Contributing to caramelize
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Daniel Senff. See LICENSE.md for further details.

