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

  show do
    attributes_table do
      row :service
      row :month
      row :published
    end

    columns do
      column do
        h2 "Transactions received"
        attributes_table do
          row :online_transactions
          row :phone_transactions
          row :paper_transactions
          row :face_to_face_transactions
          row :other_transactions
        end
      end
      column do
        h2 "Transactions processed"
        attributes_table do
          row :transactions_with_outcome
          row :transactions_with_intended_outcome
        end
      end
      column do
        h2 "Calls received"
        attributes_table do
          row :calls_received
          row :calls_received_perform_transaction
          row :calls_received_get_information
          row :calls_received_chase_progress
          row :calls_received_challenge_decision
          row :calls_received_other
        end
      end
    end
  end

  form do |_|
    inputs 'Details' do
      input :service
      input :month
      input :published
    end
    columns do
      column do
        panel "Transactions received " do
          inputs :online_transactions, :phone_transactions, :paper_transactions,
                 :face_to_face_transactions, :other_transactions
        end
      end
      column do
        panel "Transactions processed" do
          inputs :transactions_with_outcome, :transactions_with_intended_outcome
        end
      end
      column do
        panel "Calls received" do
          inputs :calls_received, :calls_received_perform_transaction, :calls_received_get_information,
                 :calls_received_chase_progress, :calls_received_challenge_decision, :calls_received_other
        end
      end
    end
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
