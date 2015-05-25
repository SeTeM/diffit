require "rails/generators"
require "generators/diffit/helpers"

module Diffit
  module Generators
    class InitGenerator < Rails::Generators::Base
      include Diffit::Generators::Helpers

      source_root File.expand_path("../templates", __FILE__)

      argument :table_name, type: :string, default: "diffits"

      def copy_initializer_file
        template "initializer.rb", config_path
      end
    end
  end
end
