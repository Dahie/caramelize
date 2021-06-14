# frozen_string_literal: true

module Caramelize
  class SwapWikiLinks
    def initialize(body)
      @body = body
    end

    # take an input stream and convert all wikka syntax to markdown syntax
    def run
      migrated_body = @body.dup

      migrated_body.gsub!(/\[\[(\S+)\|(.+?)\]\]/) { format_link(::Regexp.last_match(2), ::Regexp.last_match(1)) }
      migrated_body.gsub!(/\[\[([\w\s\-.]*)\]\]/) { format_link(::Regexp.last_match(1), ::Regexp.last_match(1).dup) }

      migrated_body
    end

    private

    def format_link(label, link)
      link.downcase!
      link.gsub!(' ', '_')
      link.gsub!('.', '')
      "[[#{label}|#{link}]]"
    end
  end
end
