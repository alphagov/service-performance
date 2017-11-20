require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovernmentServiceData
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators.system_tests = nil

    config.autoload_paths += [
      config.root.join('app', 'controllers', 'download'),
      config.root.join('app', 'importers'),
      config.root.join('app', 'models', 'metrics'),
    ]

    config.assets.paths += [
      config.root.join('vendor', 'submodules'),
      # govuk-elements-sass is in a subdirectory of govuk_elements
      config.root.join('vendor', 'submodules', 'govuk_elements', 'packages')
    ]
  end
end
