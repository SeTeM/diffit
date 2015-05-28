module Diffit
  module Generators
    module Helpers
      def self.included(base)
        base.extend(ClassMethods)
      end

      def config_path
        "config/initializers/diffit.rb"
      end

      def install_migration_path
        "db/migrate/create_#{table_name}.rb"
      end

      def create_trigger_path
        "db/migrate/create_diffit_#{table_name}_trigger.rb"
      end

      module ClassMethods
        def next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
        end
      end
    end
  end
end
