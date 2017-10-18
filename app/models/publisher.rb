class Publisher
  def self.publish(monthly_metrics)
    new.publish(monthly_metrics)
  end

  def publish(monthly_metrics)
    service = Service.find(monthly_metrics.service_id)
    beginning_of_month = monthly_metrics.month.date.beginning_of_month
    end_of_month = monthly_metrics.month.date.end_of_month

    publish_calls(service, monthly_metrics, beginning_of_month, end_of_month)
    publish_transactions_received(service, monthly_metrics, beginning_of_month, end_of_month)
    publish_transactions_with_outcome(service, monthly_metrics, beginning_of_month, end_of_month)

    monthly_metrics.published = true
    monthly_metrics.save!
  end

  def publish_transactions_received(service, monthly_metrics, beginning_of_month, end_of_month)
    mapping = delete_not_applicable_items(service,
      "online" => :online_transactions,
      "phone" => :phone_transactions,
      "paper" => :paper_transactions,
      "face-to-face" => :face_to_face_transactions,
      "other" => :other_transactions)

    delivery_org = service.delivery_organisation.natural_key
    department = service.delivery_organisation.department.natural_key

    # Delete any existing values
    TransactionsReceivedMetric.where(service_code: service.natural_key, starts_on: beginning_of_month).destroy_all

    mapping.each do |item_name, metric|
      TransactionsReceivedMetric.create!(
        department_code: department,
        delivery_organisation_code: delivery_org,
        service_code: service.natural_key,
        starts_on: beginning_of_month,
        ends_on: end_of_month,
        channel: item_name,
        quantity: monthly_metrics.send(metric)
      )
    end
  end

  def publish_transactions_with_outcome(service, monthly_metrics, beginning_of_month, end_of_month)
    mapping = delete_not_applicable_items(service,
      "any" => :transactions_with_outcome,
      "intended" => :transactions_with_intended_outcome)

    delivery_org = service.delivery_organisation.natural_key
    department = service.delivery_organisation.department.natural_key

    # Delete any existing values
    TransactionsWithOutcomeMetric.where(service_code: service.natural_key, starts_on: beginning_of_month).destroy_all

    mapping.each do |item_name, metric|
      TransactionsWithOutcomeMetric.create!(
        department_code: department,
        delivery_organisation_code: delivery_org,
        service_code: service.natural_key,
        starts_on: beginning_of_month,
        ends_on: end_of_month,
        outcome: item_name,
        quantity: monthly_metrics.send(metric),
      )
    end
  end

  def publish_calls(service, monthly_metrics, beginning_of_month, end_of_month)
    calls_mapping = delete_not_applicable_items(service,
      "total" => :calls_received,
      "get-information" => :calls_received_get_information,
      "chase-progress" => :calls_received_chase_progress,
      "challenge-a-decision" => :calls_received_challenge_decision,
      "perform-transaction" => :calls_received_perform_transaction,
      "other" => :calls_received_other)

    delivery_org = service.delivery_organisation.natural_key
    department = service.delivery_organisation.department.natural_key

    # Delete any existing values
    CallsReceivedMetric.where(service_code: service.natural_key, starts_on: beginning_of_month).destroy_all

    calls_mapping.each do |item_name, metric|
      CallsReceivedMetric.create!(
        department_code: department,
        delivery_organisation_code: delivery_org,
        service_code: service.natural_key,
        starts_on: beginning_of_month,
        ends_on: end_of_month,
        item: item_name,
        quantity: monthly_metrics.send(metric),
        sampled: false
      )
    end
  end

  def delete_not_applicable_items(service, mapping)
    items = mapping.keys.clone
    items.each do |item|
      ksym = "#{mapping[item]}_applicable".to_sym
      if !service.send(ksym)
        mapping.delete(item)
      end
    end

    mapping
  end
end
