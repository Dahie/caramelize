# frozen_string_literal: true

require 'pandoc-ruby'

module Caramelize
  class MediawikiToMarkdown
    attr_reader :source_body

    def initialize(source_body)
      @source_body = source_body
    end

    def run
      ::PandocRuby.convert(source_body.dup, from: :mediawiki, to: :markdown)
    end
  end
end
