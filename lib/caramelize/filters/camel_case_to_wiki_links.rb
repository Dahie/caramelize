# frozen_string_literal: true

module Caramelize
  class CamelCaseToWikiLinks
    def initialize(body)
      @body = body
    end

    # take an input stream and convert all wikka syntax to markdown syntax
    def run
      migrated_body = @body.dup

      migrated_body.gsub!(/([^\[\|\w\S])([A-Z]\w+[A-Z]\w+)([^\]])/) { "#{::Regexp.last_match(1)}#{format_link(::Regexp.last_match(2))}#{::Regexp.last_match(3)}" }

      migrated_body
    end

    private

    def format_link(link)
      link.tr!(" ", "_")
      link.delete!(".")
      "[[#{link}]]"
    end
  end
end
