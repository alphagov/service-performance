require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module CgsdPublishData
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators.system_tests = nil

    config.autoload_paths += [
      config.root.join('app', 'controllers', 'metrics')
    ]

    config.assets.paths += [
      config.root.join('vendor', 'submodules'),
      # govuk-elements-sass is in a subdirectory of govuk_elements
      config.root.join('vendor', 'submodules', 'govuk_elements', 'packages')
    ]
  end
end
