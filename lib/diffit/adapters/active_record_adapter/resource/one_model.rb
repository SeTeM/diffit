module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      class OneModel < Base
        def to_where
          "(#{dif_table_name}.table_name='#{table_name}'" +
            " AND #{dif_table_name}.record_id = #{id})"
        end

        def id
          object.id
        end

        def table_name
          object.class.table_name
        end

        def to_select
          column_names.map do |cn|
            "#{table_name}.#{cn} AS #{table_name}_#{cn}"
          end
        end

        def column_names
          object.class.column_names
        end

        def self.applicable?(resource)
          resource.respond_to?(:id)
        end
      end
    end
  end
end
