# frozen_string_literal: true

require "rspec/core/rake_task"
require "bundler/gem_tasks"

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["--color", "--format", "documentation"]
end

task default: :spec
