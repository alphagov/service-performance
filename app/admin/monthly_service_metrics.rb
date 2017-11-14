ActiveAdmin.register MonthlyServiceMetrics do
  includes :service, :delivery_organisation

  permit_params :id, :service_id, :month,
                :online_transactions, :phone_transactions,
                :paper_transactions, :face_to_face_transactions,
                :other_transactions, :transactions_with_outcome,
                :transactions_with_intended_outcome, :calls_received,
                :calls_received_perform_transaction, :calls_received_get_information,
                :calls_received_chase_progress, :calls_received_challenge_decision,
                :calls_received_other, :published

  index do
    selectable_column
    column :service
    column :month, sortable: :month
    column :delivery_organisation
    column :published
    actions
  end

  batch_action :publish do |ids|
    batch_action_collection.find(ids).each do |metric|
      metric.published = true
      metric.save
    end
    redirect_to collection_path, alert: "The metrics have been published."
  end

  batch_action :unpublish do |ids|
    batch_action_collection.find(ids).each do |metric|
      metric.published = false
      metric.save
    end
    redirect_to collection_path, alert: "The metrics have been unpublished."
  end
end
