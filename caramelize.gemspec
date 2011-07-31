# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "caramelize/version"

Gem::Specification.new do |s|
  s.name        = "caramelize"
  s.version     = Caramelize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license      = "MIT"
  s.authors     = ["Daniel Senff"]
  s.email       = ["mail@danielsenff.de"]
  s.homepage    = "http://github.com/Dahie/caramelize"
  s.summary     = %q{Abstract wiki convert to migrate your data from one wiki software to another}
  s.description = %q{By defining the access from the input to the output wiki you can migrate any wiki.}
  
  s.bindir = 'bin'
  
  s.add_dependency('mysql2')
  s.add_dependency('gollum', '>= 1.3.0') # grit dependency implicit through gollum

  s.rubyforge_project = "caramelize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
