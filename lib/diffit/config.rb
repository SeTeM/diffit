module Diffit
  module Config
    attr_accessor :table_name, :serializer, :timestamp_format

    def setup
      yield self
    end

    def serializer_class
      "Diffit::Serializers::#{serializer.to_s.classify}".constantize
    end
  end

  extend Config
end
