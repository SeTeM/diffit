require 'diffit/serializers/base'

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
        result = []

        iterate do |object|
          result << serialize(object)
        end

        result.as_json
      end

      def serialize(object)
        {
          model: model_for_table(object.table_name).name,
          record_id: object.record_id,
          values: values_for(object)
        }
      end

      def values_for(object)
        changed_columns = object.values.select { |k, v| v > timestamp }.keys
        changed_columns.inject({}) do |result, column|
          result[column] = object.send("#{object.table_name}_#{column}")
          result
        end
      end
    end
  end
end
