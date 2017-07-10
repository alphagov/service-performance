VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr')
  config.hook_into :faraday
end

RSpec.configure do |config|
  load_cassette = ->(example) do
    cassette = example.metadata[:cassette]

    if cassette
      VCR.use_cassette(cassette) { example.run }
    else
      example.run
    end
  end

  config.around(:each, type: :api, &load_cassette)
  config.around(:each, type: :feature, &load_cassette)
end
