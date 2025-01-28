# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "caramelize/version"

Gem::Specification.new do |spec|
  spec.name = "caramelize"
  spec.version = Caramelize::VERSION
  spec.license = "MIT"
  spec.authors = ["Daniel Senff"]
  spec.email = ["mail@danielsenff.de"]
  spec.homepage = "http://github.com/Dahie/caramelize"
  spec.summary = "Flexible and modular wiki conversion tool"
  spec.description = "With Caramelize you can migrate any wiki to git-based Gollum wiki repositories."

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3"

  spec.add_dependency("base64")
  spec.add_dependency("bigdecimal")
  spec.add_dependency("commander")
  spec.add_dependency("gollum-lib")
  spec.add_dependency("mysql2")
  spec.add_dependency("ostruct")
  spec.add_dependency("paru")
  spec.add_dependency("rdoc")
  spec.add_dependency("ruby-progressbar")

  spec.metadata["rubygems_mfa_required"] = "true"
end
