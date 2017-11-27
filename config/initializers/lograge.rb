Rails.application.configure do
  if Rails.env.production?
    config.lograge.enabled = true

    config.lograge.custom_options = lambda do |event|
      { time: event.time }
    end
  end
end
