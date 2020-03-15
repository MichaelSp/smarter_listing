# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require 'rails-controller-testing'
require "application_system_test_case"

Rails::Controller::Testing.install
Rails.backtrace_cleaner.remove_silencers!

# Consider setting MT_NO_EXPECTATIONS to not add expectations to Object.
# ENV["MT_NO_EXPECTATIONS"] = true

class ActionDispatch::IntegrationTest
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include ActiveRecord::TestFixtures
  self.fixture_path = File.expand_path('../fixtures', __FILE__)
  fixtures :all

  # Add more helper methods to be used by all tests here...
  register_spec_type /Controller$/, ActionDispatch::IntegrationTest
end