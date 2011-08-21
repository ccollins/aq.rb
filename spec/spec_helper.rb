require 'rubygems'
require 'bundler'
Bundler.setup

require 'rspec'
require 'vcr'

RSpec.configure do |config|
  config.mock_with :mocha
  config.extend VCR::RSpec::Macros
end

VCR.config do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.stub_with :fakeweb
  c.default_cassette_options = { :record => :once }
end

require File.join(File.dirname(__FILE__), "..", "lib", "aq")

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Requires shared contexts in ./shared and subdirectories
Dir["#{File.dirname(__FILE__)}/shared/**/*.rb"].each {|f| require f}