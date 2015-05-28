module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      class Base
        attr_reader :object

        def initialize(object)
          @object = object
        end

        def dif_table_name
          Model.table_name
        end

        def to_join
          "#{table_name} ON #{dif_table_name}.table_name='#{table_name}'" +
            " AND #{dif_table_name}.record_id=#{table_name}.id"
        end
      end
    end
  end
end
