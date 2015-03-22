module Caramelize
  class RemoveTableTabLineEndings

    # take an input stream and convert all wikka syntax to markdown syntax
    def run body
      migrated_body = body.dup
      migrated_body.gsub!(/\|[\t ]*\r?[\n]/, "|\n")
      migrated_body
    end
  end
end
