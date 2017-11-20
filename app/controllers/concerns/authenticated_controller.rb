module AuthenticatedController
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods

  included do
    before_action :_authenticate_with_http_basic
  end

  class_methods do
    def skip_authentication(opts = {})
      skip_before_action :_authenticate_with_http_basic, opts
    end
  end

private

  def _authenticate_with_http_basic
    return if Rails.env.development? || Rails.env.test?

    authenticate_or_request_with_http_basic('Service Performance') do |name, password|
      # This comparison uses & so that it doesn't short circuit and
      # uses `variable_size_secure_compare` so that length information
      # isn't leaked.
      ActiveSupport::SecurityUtils.variable_size_secure_compare(name, ENV.fetch('HTTP_BASIC_AUTH_USERNAME')) &
        ActiveSupport::SecurityUtils.variable_size_secure_compare(password, ENV.fetch('HTTP_BASIC_AUTH_PASSWORD'))
    end
  end
end
