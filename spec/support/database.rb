db_name = 'postgresql'
database_yml = File.expand_path('../../internal/config/database.yml', __FILE__)

if File.exist?(database_yml)
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.default_timezone = :utc
  ActiveRecord::Base.configurations = YAML.load_file(database_yml)
  # ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), '../../debug.log'))
  # ActiveRecord::Base.logger.level = ::Logger::DEBUG
  config = ActiveRecord::Base.configurations[db_name]

  begin
    ActiveRecord::Base.establish_connection(db_name.to_sym)
    ActiveRecord::Base.connection
  rescue
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => 'utf8'))

    ActiveRecord::Base.establish_connection(config)
  end

  ActiveRecord::Migrator.migrate File.expand_path("../../internal/db/migrate/", __FILE__)
  load(File.dirname(__FILE__) + '/../internal/app/models/models.rb')
else
  fail "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end
