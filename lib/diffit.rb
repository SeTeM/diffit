require 'diffit/version'

module Diffit
  require 'diffit/config'

  include Config

  require 'diffit/model'

  require 'diffit/adapters/base'

  if defined?(ActiveRecord)
    require 'diffit/adapters/active_record_adapter'

    ActiveRecord::Base.extend Diffit::Model
  end

  require 'diffit/railtie' if defined?(Rails)
end
