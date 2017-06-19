VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr')
  config.hook_into :faraday
end

RSpec.configure do |config|
  config.around(:each, type: :api) do |example|
    cassette = example.metadata[:cassette]

    if cassette
      VCR.use_cassette(cassette) { example.run }
    else
      example.run
    end
  end
end
