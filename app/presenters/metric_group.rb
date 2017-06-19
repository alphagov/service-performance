class MetricGroup < Struct.new(:name, :url, :metrics)
  module ToPartialPath
    def to_partial_path
      'metrics/' + self.class.name.demodulize.underscore
    end
  end

  def initialize(*args, delivery_organisations_count: nil, services_count: nil)
    super(*args)
    @delivery_organisations_count = delivery_organisations_count
    @services_count = services_count
  end

  attr_reader :delivery_organisations_count, :services_count

  def metrics
    @metrics ||= super.each {|metric| metric.extend(ToPartialPath) }
  end
end
