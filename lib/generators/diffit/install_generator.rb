require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'generators/diffit/helpers'

module Diffit
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      include Diffit::Generators::Helpers

      source_root File.expand_path("../templates", __FILE__)

      argument :name, type: :string, default: "diffits", banner: "table_name"

      def copy_initializer_file
        template "initializer.rb", config_path
      end

      def copy_migration_files
        migration_template "migration/diffit.rb", create_migration_path
      end
    end
  end
end
