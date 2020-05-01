require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
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
