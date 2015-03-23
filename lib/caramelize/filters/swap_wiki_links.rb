module Caramelize
  class SwapWikiLinks

    # take an input stream and convert all wikka syntax to markdown syntax
    def run body
      migrated_body = body.dup

      migrated_body.gsub!(/\[\[(\S+)\|(.+?)\]\]/, '[[\2|\1]]')
      migrated_body.gsub!(/\[\[([\w\s\.]*)\]\]/) do |s|
        if $1
          s = $1
          t = $1.dup
          t.gsub!(' ', '_')
          t.gsub!(/\./, '')
          s = "[[#{s}|#{t}]]"
        end
      end

      migrated_body
    end
  end
end
