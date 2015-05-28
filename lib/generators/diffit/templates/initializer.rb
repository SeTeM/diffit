Diffit.setup do |config|
  config.table_name = "<%= table_name %>"
  config.serializer = :json
  config.timestamp_format = ->(timestamp) { timestamp.to_s }
end
