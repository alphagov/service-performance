ActiveAdmin.register Service do
  includes :department, :delivery_organisation

  index do
    selectable_column
    column :name
    column :delivery_organisation
    column :department
    column "Owner" do |service|
      service.owner.email if service.owner
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :delivery_organisation
      row "Owner" do |service|
        service.owner.email if service.owner
      end
      row :natural_key
      row :created_at
      row :updated_at
    end

    attributes_table title: "Contextual information" do
      row "Purpose" do
        service.purpose.html_safe
      end
      row "How it works" do
        service.how_it_works.html_safe
      end
      row "Typical users" do
        service.typical_users.html_safe
      end
      row "How frequently used" do
        service.frequency_used.html_safe
      end
      row "Length of time before complete" do
        service.duration_until_outcome.html_safe
      end
      row :start_page_url
      row :paper_form_url
      row :publish_token
    end

    columns do
      column do
        attributes_table title: "Transactions received" do
          row :online_transactions_applicable
          row :phone_transactions_applicable
          row :paper_transactions_applicable
          row :face_to_face_transactions_applicable
          row :other_transactions_applicable
        end
      end
      column do
        attributes_table title: "Transactions processed" do
          row :transactions_with_outcome_applicable
          row :transactions_with_intended_outcome_applicable
        end
      end
      column do
        attributes_table title: "Calls received" do
          row :calls_received_applicable
          row :calls_received_get_information_applicable
          row :calls_received_chase_progress_applicable
          row :calls_received_challenge_decision_applicable
          row :calls_received_other_applicable
          row :calls_received_perform_transaction_applicable
        end
      end
    end
  end

  batch_action :generate_links_for do |ids|
    @page_title = "Service publishing links"

    services = batch_action_collection.find(ids)

    @service_data = services.each_with_object({}) do |service, services_hash|
      dates = 4.times.each_with_object({}) do |count, hash|
        date = (Date.today - 1.month) + count.months
        month = YearMonth.new(date.year, date.month)
        hash[date] = MonthlyServiceMetricsPublishToken.generate(service: service, month: month)
      end
      services_hash[service] = dates
    end

    render "generate_magic_links"
  end

  permit_params :id, :natural_key, :name, :owner_id,
                :created_at, :updated_at, :delivery_organisation_id,
                :purpose, :how_it_works, :typical_users, :frequency_used,
                :duration_until_outcome, :start_page_url, :paper_form_url,
                :publish_token, :online_transactions_applicable,
                :phone_transactions_applicable, :paper_transactions_applicable,
                :face_to_face_transactions_applicable, :other_transactions_applicable,
                :transactions_with_outcome_applicable, :transactions_with_intended_outcome_applicable,
                :calls_received_applicable, :calls_received_get_information_applicable,
                :calls_received_chase_progress_applicable, :calls_received_challenge_decision_applicable,
                :calls_received_other_applicable, :calls_received_perform_transaction_applicable

  remove_filter :online_transactions_applicable, :phone_transactions_applicable,
                :paper_transactions_applicable,  :face_to_face_transactions_applicable,
                :other_transactions_applicable,  :transactions_with_outcome_applicable,
                :transactions_with_intended_outcome_applicable, :calls_received_applicable,
                :calls_received_get_information_applicable, :calls_received_chase_progress_applicable,
                :calls_received_challenge_decision_applicable, :calls_received_other_applicable,
                :calls_received_perform_transaction_applicable
end
