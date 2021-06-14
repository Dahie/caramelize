# frozen_string_literal: true

module Caramelize
  module Filter
    class AddNewlineToPageEnd
      def initialize(body)
        @body = body
      end

      # take an input stream and convert all wikka syntax to markdown syntax
      def run
        return @body if @body[@body.length - 1] == "\n"

        migrated_body = @body.dup

        migrated_body << "\n"

        migrated_body
      end
    end
  end
end
