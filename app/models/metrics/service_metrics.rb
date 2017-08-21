class ServiceMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::SERVICE]
  end

  def entities
    [root]
  end
end
