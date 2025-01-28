# frozen_string_literal: true

module Caramelize
  module HealthChecks
    class HomePageCheck
      attr_reader :gollum

      def initialize(gollum)
        @gollum = gollum
      end

      def check
        puts "Home.md missing" unless has_home_page?
      end

      private

      def has_home_page? # rubocop:todo Naming/PredicateName
        gollum.file("Home")
      end
    end
  end
end
