class CrossGovernmentServiceDataAPI::Metrics

  METRICS_NAMES = [
    'transactions_received_online',
    'transactions_received_phone',
    'transactions_received_paper',
    'transactions_received_face_to_face',
    'transactions_received_other',
    'transactions_ending_any_outcome',
    'transactions_ending_user_intended_outcome'
  ]

  def self.build(response)
    department = CrossGovernmentServiceDataAPI::Department.build(response['department'])
    metrics = response.slice(*METRICS_NAMES)
    new(department, metrics)
  end

  def initialize(department, metrics)
    @department = department
    @metrics = metrics
  end
end
