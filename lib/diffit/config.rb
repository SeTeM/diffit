module Diffit
  module Config
    module ClassMethods
      attr_accessor :table_name

      def setup
        yield self
      end
    end

    extend ClassMethods

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
