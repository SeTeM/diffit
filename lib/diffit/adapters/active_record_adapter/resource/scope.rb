module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      class Scope < Base
        def to_where
          "(#{dif_table_name}.table_name='#{table_name}'" +
            " AND #{dif_table_name}.record_id in (#{ids}))"
        end

        def ids
          object.select(:id).to_sql
        end

        def table_name
          object.table_name
        end

        def to_select
          column_names.map do |cn|
            "#{table_name}.#{cn} AS #{table_name}_#{cn}"
          end
        end

        def column_names
          object.column_names
        end

        def self.applicable?(resource)
          resource.respond_to?(:ancestors) &&
            resource.ancestors.include?(ActiveRecord::Base)
        end
      end
    end
  end
end
