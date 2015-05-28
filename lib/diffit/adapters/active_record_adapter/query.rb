module Diffit::Adapters
  module ActiveRecordAdapter
    class Query
      attr_reader :timestamp, :resources

      UnexpectedRecord = Class.new(StandardError)
      CantFindTableName = Class.new(StandardError)
      CantFindColumns = Class.new(StandardError)

      def initialize(timestamp, options={})
        @timestamp = timestamp
        @resources = options[:resources]
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
        resources.map { |r| resource_to_where(r) }.join(' OR ')
      end

      def resource_to_where(resource)
        resource_table_name = table_name_for(resource)
        if resource.respond_to?(:id)
          "(#{dif_table_name}.table_name='#{resource_table_name}'" +
            " AND #{dif_table_name}.record_id = #{resource.id})"
        elsif resource.ancestors.include?(ActiveRecord::Base)
          "(#{dif_table_name}.table_name='#{resource_table_name}'" +
            " AND #{dif_table_name}.record_id in (#{resource.select(:id).to_sql}))"
        else
          raise UnexpectedRecord, resource
        end
      end

      def join_clause
        "INNER JOIN " + resources.map do |resource|
          resource_table_name = table_name_for(resource)
          "#{resource_table_name} ON #{dif_table_name}.table_name='#{resource_table_name}'" +
            " AND #{dif_table_name}.record_id=#{resource_table_name}.id"
        end.uniq.join(', ')
      end

      def table_name_for(resource)
        if resource.respond_to?(:table_name)
          resource.table_name
        elsif resource.class.respond_to?(:table_name)
          resource.class.table_name
        else
          raise CantFindTableName, resource
        end
      end

      def select_clause
        "#{dif_table_name}.*, " + resources.flat_map do |resource|
          record_to_select(resource)
        end.uniq.join(', ')
      end

      def record_to_select(resource)
        resource_table_name = table_name_for(resource)
        if resource.respond_to?(:column_names)
          resource.column_names
        elsif resource.class.respond_to?(:column_names)
          resource.class.column_names
        else
          raise CantFindColumns, resource
        end.map do |cn|
          "#{resource_table_name}.#{cn} AS #{resource_table_name}_#{cn}"
        end
      end

      def dif_table_name
        Model.table_name
      end
    end
  end
end
