class ServiceMetrics < Metrics
  def self.supported_groups
    [Group::Service]
  end

  def entities
    [root]
  end
end
