# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../../../../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + "/blueprints")
 
include AuthenticatedSystem
include AuthenticatedTestHelper
include RubricCms

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  config.before(:each) { Sham.reset }
end

# Helper methods

def login_as_admin
  _user = User.make :role => ( Role.admin.first || Role.make(:admin) ), :state => 'active'
  login_as _user
  _user
end

# Workarounds for application helper methods unavailable in the test environment
def content_for(name)
  response.template.instance_variable_get("@content_for_#{name}")
end

def number_to_human_size(number, *args)
  number
end
