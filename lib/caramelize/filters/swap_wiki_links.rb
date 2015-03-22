module Caramelize
  class SwapWikiLinks

    # take an input stream and convert all wikka syntax to markdown syntax
    def run body
      migrated_body = body.dup

      migrated_body.gsub!(/\[\[(\S+)\|(.+?)\]\]/, '[[\2|\1]]')
      #migrated_body.gsub!(/\[\[([\w\s]*)\]\]/) do |s|
      #  if $1
      #    s = "[[#{$1}|#{$1.gsub(' ', '_')}]]"
      #  end
      #end

      migrated_body
    end
  end
end
