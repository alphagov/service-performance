class ServiceMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Service]
  end

  def entities
    [root]
  end
end
