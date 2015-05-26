module Diffit
  module Serializers
    class Base
      attr_reader :objects

      def initialize(objects)
        @objects = objects
      end

      protected

      def formatted_time
        Time.now.to_s
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
