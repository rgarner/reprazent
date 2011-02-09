$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)
require '../lib/reprazent'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

# The minimal Rails project was created to run specs against using:
# rails -m http://github.com/robinsp/rails_templates/raw/master/minimal.rb railsenv

#plugin_spec_dir = File.dirname(__FILE__)
#ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")
#
#dir = File.expand_path(File.dirname(__FILE__))
#require "#{dir}/../lib/robins_html_helpers"
#require "#{dir}/../lib/robins_html_helpers/form_builder"
