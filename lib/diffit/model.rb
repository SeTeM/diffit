module Diffit
  module Model
    def diffit!
      extend ClassMethods
      include InstanceMethods
    end

    private

    module ClassMethods
      def diff_from(timestamp)
      end
    end

    module InstanceMethods
      def diff_from(timestamp)
      end
    end
  end
end
