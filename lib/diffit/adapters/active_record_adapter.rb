module Diffit
  module Adapters
    class ActiveRecordAdapter < Base
      def diff_from(timestamp)
        puts "AAA from #{Diffit::Config.table_name}"
      end
    end
  end
end
