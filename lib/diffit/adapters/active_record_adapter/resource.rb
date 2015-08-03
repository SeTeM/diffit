require 'diffit/adapters/active_record_adapter/resource/base'
require 'diffit/adapters/active_record_adapter/resource/one_model'
require 'diffit/adapters/active_record_adapter/resource/scope'

module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      UnexpectedResource = Class.new(StandardError)

      def self.load(resource)
        if is_one_model?(resource)
          OneModel.new(resource)
        elsif is_scope?(resource)
          Scope.new(resource)
        elsif is_array?(resource)
          resource.map { |r| OneModel.new(r) }
        else
          raise UnexpectedResource, resource
        end
      end

      private

      def self.is_one_model?(resource)
        resource.respond_to?(:id)
      end

      def self.is_scope?(resource)
        resource.respond_to?(:ancestors) &&
            resource.ancestors.include?(ActiveRecord::Base)
      end

      def self.is_array?(resource)
        resource.is_a?(Array)
      end
    end
  end
end
