class Completeness
  def self.multiplier(obj)
    return 1 if obj === Service
    obj.services.count
  end
end
