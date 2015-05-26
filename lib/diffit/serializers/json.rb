module Diffit
  module Serializers
    class Json < Base
      def dump
        {
          timestamp: formatted_time,
          changes: changes
        }
      end

      private

      def changes
        changes = []

        iterate do |object|
          changes << serialize(object)
        end

        changes
      end

      def serialize(object)
        object.to_s
      end
    end
  end
end
