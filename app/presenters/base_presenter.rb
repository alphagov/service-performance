class BasePresenter < SimpleDelegator
  alias :read_attribute_for_serialization :send

  def initialize(model, time_period)
    @model, @time_period = model, time_period
    super(@model)
  end
end
