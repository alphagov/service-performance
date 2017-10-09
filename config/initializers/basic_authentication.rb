unless Rails.env.development? || Rails.env.test?
  Rails.application.configure do
    config.middleware.use Rack::Auth::Basic, 'Government Service Data' do |username, password|
      username == ENV.fetch('HTTP_BASIC_AUTH_USERNAME') && password == ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
    end
  end
end
