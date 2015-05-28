module Diffit
  module Serializers
    class Base
      attr_reader :objects, :timestamp

      def initialize(timestamp, objects)
        @timestamp = timestamp
        @objects = objects
      end

      protected

      def formatted_time
        timestamp.to_s
      end

      def iterate
        objects.public_send(iterate_method) do |object|
          yield object
        end
      end

      def iterate_method
        objects.respond_to?(:find_each) ? :find_each : :each
      end
    end
  end
end
