# frozen_string_literal: true

module Caramelize
  module Services
    class PageBuilder
      HEADLINE = "## Overview of namespaces\n"

      def self.build_namespace_overview(namespaces)
        # TODO: change wiki as configurable default home
        # TODO support other markup syntaxes

        body = namespaces.map do |namespace|
          "* [[#{namespace[:name]}|#{namespace[:identifier]}/wiki]]"
        end.prepend(HEADLINE).join("  \n")

        Page.new(title: 'Home',
                 body:,
                 message: 'Create Namespace Overview',
                 latest: true)
      end
    end
  end
end
