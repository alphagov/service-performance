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

  config.around(:each, :cassette, &load_cassette)
end
