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

        changes.as_json
      end

      def serialize(object)
        changed_columns = object.values.select { |k, v| v > timestamp }.keys

        changed_columns.inject({}) do |result, column|
          result[column] = object.send("#{object.table_name}_#{column}")
          result
        end
      end
    end
  end
end
