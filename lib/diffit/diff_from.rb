module Diffit
  module DiffFrom
    def diff_from(timestamp, options={})
      scope = Diffit::Query.new(timestamp, options).search
      Diffit.serializer_class.new(timestamp, scope).dump
    end
  end

  extend Diffit::DiffFrom
end
