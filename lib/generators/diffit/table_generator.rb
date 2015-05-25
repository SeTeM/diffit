require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'generators/diffit/helpers'

module Diffit
  module Generators
    class TableGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      include Diffit::Generators::Helpers

      source_root File.expand_path("../templates/migration", __FILE__)

      def copy_migration_files
        migration_template "create_trigger.rb", create_trigger_path
      end
    end
  end
end
