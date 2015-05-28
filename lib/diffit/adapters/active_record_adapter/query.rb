require 'diffit/adapters/active_record_adapter/resource'

module Diffit::Adapters
  module ActiveRecordAdapter
    class Query
      attr_reader :timestamp, :resources

      def initialize(timestamp, options={})
        @timestamp = timestamp
        @resources = options[:resources].flat_map { |r| Resource.load(r) }
      end

      def search
        return Model.none if resources.blank?

        Model
          .select(select_clause)
          .joins(join_clause)
          .where(Model.arel_table[:last_changed_at].gt(timestamp))
          .where(where_clause)
      end

      private

      def where_clause
        resources.map(&:to_where).join(' OR ')
      end

      def join_clause
        "INNER JOIN " + resources.map(&:to_join).uniq.join(', ')
      end

      def select_clause
        "#{dif_table_name}.*, " + resources.flat_map(&:to_select).uniq.join(', ')
      end

      def dif_table_name
        Model.table_name
      end
    end
  end
end
