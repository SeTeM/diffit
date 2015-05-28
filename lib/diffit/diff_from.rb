module Diffit
  module DiffFrom
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def diff_from(timestamp, options={})
        scope = Diffit::Query.new(timestamp, options).search
        Diffit.serializer_class.new(timestamp, scope).dump
      end
    end
  end
end
