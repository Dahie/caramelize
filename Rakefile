require 'bundler'
require 'rdoc/task'

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include( "lib/**/*.rb")
end