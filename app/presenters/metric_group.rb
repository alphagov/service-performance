class MetricGroup < Struct.new(:name, :url, :metrics)
  module ToPartialPath
    def to_partial_path
      'metrics/' + self.class.name.demodulize.underscore
    end
  end

  def metrics
    @metrics ||= super.each {|metric| metric.extend(ToPartialPath) }
  end
end
