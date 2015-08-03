require 'diffit/adapters/active_record_adapter/resource/base'
require 'diffit/adapters/active_record_adapter/resource/one_model'
require 'diffit/adapters/active_record_adapter/resource/scope'
require 'diffit/adapters/active_record_adapter/resource/array_of_models'

module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      RESOURCE_CLASSES = [OneModel, Scope, ArrayOfModels].freeze

      UnexpectedResource = Class.new(StandardError)

      def self.load(resource)
        klass = RESOURCE_CLASSES.detect { |k| k.applicable?(resource) }

        if klass
          klass.new(resource)
        else
          raise UnexpectedResource, resource
        end
      end
    end
  end
end
