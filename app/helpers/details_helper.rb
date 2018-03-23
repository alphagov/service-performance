module DetailsHelper
  def trxn_rx_metrics
    %w(total online phone email paper face_to_face other)
  end

  def trxn_proc_metrics
    %w(total accepted rejected)
  end

  def calls_rx_metrics
    %w(total perform_transaction get_information chase_progress challenge_a_decision other)
  end

  def trxn_rx_metric_label(m)
    I18n.translate(m, scope: %w(helpers missing TransactionsReceivedMetric))
  end

  def trxn_proc_metric_label(m)
    I18n.translate(m, scope: %w(helpers missing TransactionsProcessedMetric))
  end

  def calls_metric_label(m)
    I18n.translate(m, scope: %w(helpers missing CallsReceivedMetric))
  end

  def received_not_applicable?(svc)
    [
      svc.online_transactions_applicable,
      svc.phone_transactions_applicable,
      svc.email_transactions_applicable,
      svc.paper_transactions_applicable,
      svc.face_to_face_transactions_applicable,
      svc.other_transactions_applicable
    ].none?
  end

  def processed_not_applicable?(svc)
    [svc.transactions_processed_applicable, svc.transactions_processed_accepted_applicable, svc.transactions_processed_rejected_applicable].none?
  end

  def calls_not_applicable?(svc)
    [
      svc.calls_received_applicable,
      svc.calls_received_get_information_applicable,
      svc.calls_received_chase_progress_applicable,
      svc.calls_received_challenge_decision_applicable,
      svc.calls_received_other_applicable,
      svc.calls_received_perform_transaction_applicable
    ].none?
  end
end
