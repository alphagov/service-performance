module ErrorsHelper
  def field_has_errors(metrics, field)
    field_errors(metrics, field).any?
  end

  def field_errors(metrics, field)
    metrics.errors.full_messages_for(field)
  end

  def metric_errors(metrics)
    metrics.errors.messages
  end
end
