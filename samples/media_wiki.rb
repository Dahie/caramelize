# frozen_string_literal: true

# Connecting to the MediaWiki Docker setup  at https://hub.docker.com/_/mediawiki/

def input_wiki
  options = {
    host: '0.0.0.0',
    username: 'wikiuser',
    password: 'example',
    database: 'my_wiki',
    port: 63_645
  }
  Caramelize::InputWiki::MediaWiki.new(options)
end
