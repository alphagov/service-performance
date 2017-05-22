class MetricGroup < Struct.new(:name, :url, :metrics)
  module ToPartialPath
    def to_partial_path
      'metrics/' + self.class.name.demodulize.underscore
    end
  end

  def initialize(*args, agencies_count: nil, services_count: nil)
    super(*args)
    @agencies_count = agencies_count
    @services_count = services_count
  end

  attr_reader :agencies_count, :services_count

  def metrics
    @metrics ||= super.each {|metric| metric.extend(ToPartialPath) }
  end
end
