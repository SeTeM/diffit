$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

begin
  require 'byebug'
rescue LoadError
end

require 'active_record'
require 'database_cleaner'

require 'rails'
require 'rspec/its'

require 'diffit'

I18n.enforce_available_locales = true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

Dir[File.join(Dir.pwd, 'spec/support/**/*.rb')].sort.each{ |f| require f }
