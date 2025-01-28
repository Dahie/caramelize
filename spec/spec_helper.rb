# frozen_string_literal: true

require "caramelize"

Dir[("./spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # config.include TestHelpers
end
