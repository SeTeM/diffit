module Diffit::Adapters
  module ActiveRecordAdapter
    module Extension
      def diffit!
        extend DiffFromMethod
        include DiffFromMethod
      end

      private

      module DiffFromMethod
        def diff_from(timestamp)
          Diffit.diff_from(timestamp, resources: [self])
        end
      end
    end
  end
end
