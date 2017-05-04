require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module CgsdViewData
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators.system_tests = nil
  end
end
