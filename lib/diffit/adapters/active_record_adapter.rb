require 'diffit/adapters/active_record_adapter/extension'
require 'diffit/adapters/active_record_adapter/model'
require 'diffit/adapters/active_record_adapter/query'

module Diffit
  ActiveRecord::Base.extend Diffit::Adapters::ActiveRecordAdapter::Extension
  Model = Diffit::Adapters::ActiveRecordAdapter::Model
  Query = Diffit::Adapters::ActiveRecordAdapter::Query
end
