# frozen_string_literal: true

require "paru/pandoc"

module Caramelize
  class MediawikiToMarkdown
    attr_reader :source_body

    def initialize(source_body)
      @source_body = source_body
    end

    def run
      Paru::Pandoc.new do
        from "mediawiki"
        to "markdown"
        markdown_headings "atx"
      end << source_body.dup
    end
  end
end
