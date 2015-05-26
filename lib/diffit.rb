require 'diffit/version'

module Diffit
  require 'diffit/config'

  include Config

  require 'diffit/serializers/base'
  require 'diffit/serializers/json'

  require 'diffit/diff_from'
  include Diffit::DiffFrom

  if defined?(ActiveRecord)
    require 'diffit/adapters/active_record/extension'
    ActiveRecord::Base.extend Diffit::Adapters::ActiveRecord::Extension

    require 'diffit/adapters/active_record/model'
    Model = Diffit::Adapters::ActiveRecord::Model

    require 'diffit/adapters/active_record/query'
    Query = Diffit::Adapters::ActiveRecord::Query
  end

  require 'diffit/railtie' if defined?(Rails)
end
