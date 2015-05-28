module Diffit::Adapters
  module ActiveRecordAdapter
    class Query
      attr_reader :timestamp, :records

      UnexpectedRecord = Class.new(StandardError)

      def initialize(timestamp, options={})
        @timestamp = timestamp
        @records = options[:records]
      end

      def search
        Model
          .where(Model.arel_table[:last_changed_at].gt(timestamp))
          .where(where_clause)
      end

      private

      def where_clause
        records.map { |r| record_to_sql(r) }.join(' OR ')
      end

      def record_to_sql(record)
        # byebug
        if record.kind_of?(ActiveRecord::Relation)
          "(#{dif_table_name}.table_name='#{record.table_name}'" +
            " AND #{dif_table_name}.record_id in (#{record.select(:id).to_sql}))"
        elsif record.kind_of?(ActiveRecord::Base)
          "(#{dif_table_name}.table_name='#{record.table_name}'" +
            " AND #{dif_table_name}.record_id = #{record.id})"
        else
          raise UnexpectedRecord, record.class
        end
      end

      def dif_table_name
        Model.table_name
      end
    end
  end
end
