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

if ENV["VCAP_SERVICES"]
  services = JSON.parse(ENV["VCAP_SERVICES"])

  if services.keys.include?('user-provided')
    # Extract UPSes and pull out secrets configs
    user_provided_services = services['user-provided'].select { |s| s['name'].include?('credentials') }
    credentials = user_provided_services.map { |s| s['credentials'] }.reduce(:merge)

    # Take each credential and assign to ENV
    credentials.each do |k, v|
      # Don't overwrite existing env vars
      ENV[k.upcase] ||= v
    end
  end
end

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
