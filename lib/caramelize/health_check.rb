# frozen_string_literal: true

module Caramelize
  class HealthCheck
    attr_reader :wiki_path, :options

    def initialize(wiki_path, options = {})
      @wiki_path = wiki_path
      @options = options
    end

    def execute
      HealthChecks::HomePageCheck.new(gollum).check
      HealthChecks::OrphanedPagesCheck.new(gollum).check
    end

    private

    def gollum
      @gollum ||= ::Gollum::Wiki.new(wiki_path, {ref: "main"})
    end
  end
end
