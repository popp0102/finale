require 'simplecov'

SimpleCov.start do
  add_filter do |source_file|
    if (source_file.filename.match? 'client_mock.rb')
      false
    else
      source_file.filename.match? '/spec/'
    end
  end
  enable_coverage :branch
end

require 'bundler/setup'
require 'factory_bot'
require 'webmock/rspec'
require 'pry'

require 'finale'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions
end
