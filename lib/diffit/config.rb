module Diffit
  module Config
    module ClassMethods
      attr_accessor :table_name, :serializer, :timestamp_format

      def setup
        yield self
      end

      def serializer_class
        "Diffit::Serializers::#{serializer.to_s.classify}".constantize
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end

  include Config
end
