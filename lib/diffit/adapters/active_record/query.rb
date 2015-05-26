module Diffit::Adapters
  module ActiveRecord
    class Query
      attr_reader :timestamp, :records, :scopes

      def initialize(timestamp, options={})
        @timestamp = timestamp
        @records = options[:records]
        @scopes = options[:scopes]
      end

      def search
        Model
          .where(Model.arel_table[:changed_at].gt(timestamp))
          .where(where_clause)
      end

      private

      def where_clause
        scopes.map do |scope|
          "(table_name='#{scope.table_name}' AND record_id in (#{scope.select(:id).to_sql}))"
        end.join(' OR ')
      end
    end
  end
end
