module Diffit::Adapters
  module ActiveRecordAdapter
    class Query
      attr_reader :timestamp, :records

      UnexpectedRecord = Class.new(StandardError)
      CantFindTableName = Class.new(StandardError)

      def initialize(timestamp, options={})
        @timestamp = timestamp
        @records = options[:records]
      end

      def search
        return Model.none if records.blank?

        Model
          .select(select_clause)
          .joins(join_clause)
          .where(Model.arel_table[:last_changed_at].gt(timestamp))
          .where(where_clause)
      end

      private

      def where_clause
        records.map { |r| record_to_where(r) }.join(' OR ')
      end

      def record_to_where(record)
        record_table_name = table_name_for(record)
        if record.respond_to?(:id)
          "(#{dif_table_name}.table_name='#{record_table_name}'" +
            " AND #{dif_table_name}.record_id = #{record.id})"
        elsif record.ancestors.include?(ActiveRecord::Base)
          "(#{dif_table_name}.table_name='#{record_table_name}'" +
            " AND #{dif_table_name}.record_id in (#{record.select(:id).to_sql}))"
        else
          raise UnexpectedRecord, record
        end
      end

      def join_clause
        "INNER JOIN " + records.map do |record|
          record_table_name = table_name_for(record)
          "#{record_table_name} ON #{dif_table_name}.table_name='#{record_table_name}'" +
            " AND #{dif_table_name}.record_id=#{record_table_name}.id"
        end.uniq.join(', ')
      end

      def table_name_for(record)
        if record.respond_to?(:table_name)
          record.table_name
        elsif record.class.respond_to?(:table_name)
          record.class.table_name
        else
          raise CantFindTableName, record
        end
      end

      def select_clause
        "#{dif_table_name}.*, " + records.flat_map do |record|
          record_to_select(record)
        end.uniq.join(', ')
      end

      def record_to_select(record)
        record_table_name = table_name_for(record)
        if record.respond_to?(:column_names)
          record.column_names
        elsif record.class.respond_to?(:column_names)
          record.class.column_names
        end.map { |cn| "#{record_table_name}.#{cn} AS #{record_table_name}_#{cn}" }
      end

      def dif_table_name
        Model.table_name
      end
    end
  end
end
