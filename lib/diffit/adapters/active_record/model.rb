module Diffit::Adapters
  module ActiveRecord
    class Model < ::ActiveRecord::Base

      def self.table_name
        Diffit.table_name
      end
    end
  end
end
