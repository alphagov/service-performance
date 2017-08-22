require 'uri'

module GovernmentOrganisationRegister
  class PageLinksParser < Faraday::Response::Middleware
    def on_complete(env)
      header = env[:response_headers]['Link']
      links = LinkHeader.parse(header).to_a
      env[:links] = links.each.with_object({}) do |(uri, attributes), links|
        uri = URI.parse(uri)
        _, relationship = attributes.detect { |(key, _value)| key == 'rel' }

        links[relationship.to_sym] = uri
      end
    end
  end

  class Organisations < Enumerator
    ORGANISATIONS_URL = URI("https://government-organisation.register.gov.uk/records.json")

    def initialize(page_size: 5000)
      url = ORGANISATIONS_URL.dup
      url.query = "page-size=#{page_size}"

      super() do |yielder|
        while url do
          response = connection.get(url)
          response.body.each do |_, record|
            organisation = Organisation.new(record)
            yielder.yield organisation
          end

          next_path = response.env[:links][:next]
          url = next_path && (url + next_path)
        end
      end
    end

  private

    def connection
      @connection ||= Faraday.new do |client|
        client.use PageLinksParser
        client.response :json
        client.adapter  Faraday.default_adapter
      end
    end
  end
end
