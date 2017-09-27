class MonthlyServiceMetricsPublishToken
  def self.generate(service:, month:)
    verifier = ActiveSupport::MessageVerifier.new(service.publish_token)
    verifier.generate(year: month.year, month: month.month)
  end

  def self.valid?(token:, metrics:)
    raise ArgumentError, 'MonthlyServiceMetrics#month must be set' if metrics.month.nil?
    raise ArgumentError, 'MonthlyServiceMetrics#service must be set' if metrics.service.nil?

    service = metrics.service
    verifier = ActiveSupport::MessageVerifier.new(service.publish_token)
    payload = verifier.verify(token)

    payload.fetch(:year) == metrics.month.year && payload.fetch(:month) == metrics.month.month
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    false
  end
end
