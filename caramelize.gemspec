# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "caramelize/version"

Gem::Specification.new do |spec|
  spec.name        = "caramelize"
  spec.version     = Caramelize::VERSION
  spec.license      = "MIT"
  spec.authors     = ["Daniel Senff"]
  spec.email       = ["mail@danielsenff.de"]
  spec.homepage    = "http://github.com/Dahie/caramelize"
  spec.summary     = %q{Flexible and modular wiki conversion tool}
  spec.description = %q{By defining the connectors from the input wiki you can migrate any wiki to git-based Gollum wiki repositories.}

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('mysql2')
  spec.add_dependency('commander')
  spec.add_dependency('docile')
  spec.add_dependency('ruby-progressbar')
  spec.add_dependency('gollum-lib')

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
