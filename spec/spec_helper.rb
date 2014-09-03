$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'usesguid'
require 'rspec'
require 'rspec/autorun'

RSpec::Runner.configure do |config|
  
end
