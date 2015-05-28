module Diffit
  module Serializers
    class Base
      attr_reader :objects, :timestamp

      def initialize(timestamp, objects)
        @timestamp = timestamp
        @objects = objects
        load_all_models
      end

      protected

      def formatted_time
        Diffit.timestamp_format.call(timestamp)
      end

      def iterate
        objects.public_send(iterate_method) do |object|
          yield object
        end
      end

      def iterate_method
        objects.respond_to?(:find_each) ? :find_each : :each
      end

      def model_for_table(table)
        models_by_table[table]
      end

      def models_by_table
        @models_by_table ||= ActiveRecord::Base.subclasses.index_by(&:table_name)
      end

      def load_all_models
        return unless Rails.root
        Dir[Rails.root.join("app", "models", "**", "*.rb")].each(&method(:require))
      end
    end
  end
end
