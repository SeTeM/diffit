module Diffit::Adapters
  module ActiveRecordAdapter
    module Resource
      class ArrayOfModels
        def initialize(resources)
          resources.map { |r| OneModel.new(r) }
        end

        def self.applicable?(resource)
          resource.is_a?(Array)
        end
      end
    end
  end
end
