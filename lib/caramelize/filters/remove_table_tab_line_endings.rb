# frozen_string_literal: true

module Caramelize
  class RemoveTableTabLineEndings
    def initialize(body)
      @body = body
    end

    # take an input stream and convert all wikka syntax to markdown syntax
    def run
      migrated_body = @body.dup
      migrated_body.gsub!(/\|[\t ]*\r?\n/, "|\n")
      migrated_body
    end
  end
end
