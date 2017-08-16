class GovernmentServiceDataAPI::Logger < Faraday::Response::Middleware
  extend Forwardable

  def initialize(app, logger: Rails.logger)
    super(app)
    @logger = logger
    @level = :info
  end

  def call(env)
    log(:request, "#{env.method.upcase} #{env.url}")
    log(:request, "")
    env.request_headers.each do |key, value|
      log(:request, "#{key}: #{value}")
    end
    log(:request, "")

    super
  end

  def on_complete(env)
    log(:response, "#{env.status} #{env.reason_phrase}")
    log(:response, "")
    env.response_headers.each do |key, value|
      log(:response, "#{key}: #{value}")
    end
    log(:response, "")
    env.body.each_line do |line|
      log(:response, line.chomp.to_s)
    end
  end


private

  def log(type, message)
    direction = case type
                when :request
                  "===>"
                when :response
                  "<==="
                end

    @logger.tagged('GovernmentServiceDataAPI') do
      @logger.send(@level, "#{direction} #{message}")
    end
  end
end
