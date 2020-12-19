module Caramelize
  module Services
    class PageBuilder
      def self.build_namespace_overview(namespaces)
        body = "## Overview of namespaces\n\n"

        namespaces.each do |namespace|
          # TODO change wiki as configurable default home
          # TODO support other markup syntaxes
          body << "* [[#{namespace[:name]}|#{namespace[:identifier]}/wiki]]  \n"
        end

        Page.new(title: "Home",
                 body: body,
                 message: 'Create Namespace Overview',
                 latest: true)
      end
    end
  end
end
