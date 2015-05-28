require 'diffit/version'

module Diffit
  require 'diffit/config'

  require 'diffit/diff_from'

  require 'diffit/serializers/json'

  require 'diffit/adapters/active_record_adapter' if defined?(ActiveRecord)

  require 'diffit/railtie' if defined?(Rails)
end
