require 'diffit/adapters/active_record_adapter/resource/base'
require 'diffit/adapters/active_record_adapter/resource/one_model'
require 'diffit/adapters/active_record_adapter/resource/scope'

module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      UnexpectedResource = Class.new(StandardError)

      def self.load(resource)
        if resource.respond_to?(:id)
          OneModel.new(resource)
        elsif resource.respond_to?(:ancestors) &&
            resource.ancestors.include?(ActiveRecord::Base)
          Scope.new(resource)
        elsif resource.is_a?(Array)
          resource.map { |r| OneModel.new(r) }
        else
          raise UnexpectedResource, resource
        end
      end
    end
  end
end
