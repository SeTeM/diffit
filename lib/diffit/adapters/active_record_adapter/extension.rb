module Diffit::Adapters
  module ActiveRecordAdapter
    module Extension
      def diffit!
        extend ClassMethods
        include InstanceMethods
      end

      private

      module ClassMethods
        def diff_from(timestamp)
          Diffit.diff_from(timestamp, records: [self])
        end
      end

      module InstanceMethods
        def diff_from(timestamp)
          Diffit.diff_from(timestamp, records: [self])
        end
      end
    end
  end
end
