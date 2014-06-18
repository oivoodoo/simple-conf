$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'simple-conf'

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.mock_with :rspec

  config.backtrace_exclusion_patterns = [%r{lib\/rspec\/(core|expectations|matchers|mocks)}]
end
