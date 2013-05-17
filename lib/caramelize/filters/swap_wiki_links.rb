#Encoding: UTF-8
module Caramelize
  class SwapWikiLinks

    # take an input stream and convert all wikka syntax to markdown syntax
    def run body
      body = body.dup

      body.gsub!(/\[\[(\S+)\|(.+?)\]\]/, '[[\2|\1]]')
      body.gsub!(/\[\[([\w\s-]*)\]\]/) do |s|
      	if $1
      		t = $1.dup
      		s = '[[' +t + "|"+ $1.gsub(' ', '_') + "]]"
      	end
      end

      body
    end
  end
end
