module GovernmentOrganisationRegister
  class Organisation
    def initialize(data)
      item = data['item'].first

      @key = data['key']
      @name = item['name']
      @website = item['website']
      @end_date = parse_date(item['end-date'])
    end

    attr_reader :key, :name, :website, :end_date

    def retired?
      end_date && (end_date < Date.today)
    end

    private

    DATE_PATTERN = /(?<year>\d{4})(-(?<month>\d{2})(-(?<day>\d{2}))?)?/

    def parse_date(date)
      return if date.nil?

      match = date.match(DATE_PATTERN)
      raise ArgumentError.new("unexpected date format: '%s'" % date) unless match

      captures = match.named_captures
      components = [captures['year'], captures['month'], captures['day']].compact.map(&:to_i)

      Date.new(*components)
    end
  end
end
