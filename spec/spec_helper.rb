require 'pry'
require 'caramelize'

Dir[('./spec/support/**/*.rb')].each {|f| require f}

#require File.join('lib', 'pixi_client', 'requests', 'itemable_shared_examples')

RSpec.configure do |config|
  #config.include TestHelpers
end