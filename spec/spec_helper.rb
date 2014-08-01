require 'thousand_island'

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
  config.order = :random

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
