ActiveAdmin.register MonthlyServiceMetrics do
  includes :service, :delivery_organisation

  permit_params :id, :service_id, :month,
                :online_transactions, :phone_transactions,
                :paper_transactions, :face_to_face_transactions,
                :other_transactions, :transactions_processed,
                :transactions_processed_with_intended_outcome, :calls_received,
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

    svc = monthly_service_metrics.service
    def applicable_value(service, val)
      appl = service.send("#{val}_applicable")
      if !appl
        "Not applicable"
      else
        monthly_service_metrics.send(val)
      end
    end

    columns do
      column do
        h2 "Transactions received"
        attributes_table do
          row "Online" do
            applicable_value(svc, :online_transactions)
          end
          row "Phone" do
            applicable_value(svc, :phone_transactions)
          end
          row "Paper" do
            applicable_value(svc, :paper_transactions)
          end
          row "Face to face" do
            applicable_value(svc, :face_to_face_transactions)
          end
          row "Other" do
            applicable_value(svc, :other_transactions)
          end
        end
      end
      column do
        h2 "Transactions processed"
        attributes_table do
          row "Total" do
            applicable_value(svc, :transactions_processed)
          end
          row "With intended outcome" do
            applicable_value(svc, :transactions_processed_with_intended_outcome)
          end
        end
      end
      column do
        h2 "Calls received"
        attributes_table do
          row "Total" do
            applicable_value(svc, :calls_received)
          end
          row "To perform a transaction" do
            applicable_value(svc, :calls_received_perform_transaction)
          end
          row "To get information" do
            applicable_value(svc, :calls_received_get_information)
          end
          row "To chase progress" do
            applicable_value(svc, :calls_received_chase_progress)
          end
          row "To challenge a decision" do
            applicable_value(svc, :calls_received_challenge_decision)
          end
          row "Other" do
            applicable_value(svc, :calls_received_other)
          end
        end
      end
    end

    panel "Versions" do
      table_for PaperTrail::Version.where(item_type: "MonthlyServiceMetrics").order('id desc') do
        column "Event", :event
        column("Modified at") { |v| v.created_at.to_s :long }
        column("Modified by") { |v|
          if v.whodunnit.in? ["Unknown user", nil]
            "Unknown user"
          else
            link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)]
          end
        }
        column("Changes") { |v|
          return '' if !v.changeset

          changes = v.changeset
          data = changes.inject([]) do |memo, (k, val)|
            if k == "updated_at"
              memo << ""
            else
              change_from, change_to = val
              memo << "Field '#{k}' changed\n from '#{change_from}'\nto '#{change_to}'\n\n"
            end
          end
          simple_format(data.join)
        }
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
          inputs :transactions_processed, :transactions_processed_with_intended_outcome
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
