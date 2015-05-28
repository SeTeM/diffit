require 'diffit/version'

module Diffit
  require 'diffit/config'

  include Config

  require 'diffit/serializers/base'
  require 'diffit/serializers/json'

  require 'diffit/diff_from'
  include Diffit::DiffFrom

  require 'diffit/adapters/active_record_adapter' if defined?(ActiveRecord)

  require 'diffit/railtie' if defined?(Rails)
end
