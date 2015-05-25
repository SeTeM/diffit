module Diffit
  class Railtie < Rails::Railtie
    config.diffit = Diffit::Configuration
  end
end
