ActiveAdmin.register Service do
  includes :department, :delivery_organisation

  controller do
    defaults finder: :find_by_natural_key
  end

  index do
    selectable_column
    column :name
    column :delivery_organisation
    column :department
    column "Context?" do |s|
      status_tag("Missing", class: "error") if [s.purpose, s.how_it_works, s.typical_users, s.start_page_url].any?(&:blank?)
    end
    actions
  end

  show do
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    attributes_table do
      row :name
      row :delivery_organisation
      row("Owner", &:owner)
      row :natural_key
      row :created_at
      row :updated_at
      row "Label for other field" do |service|
        service.other_name || ""
      end
      row "Label for other calls field" do |service|
        service.calls_other_name || ""
      end
      row("Are calls sampled?", &:sampled_calls)
    end

    attributes_table title: "Contextual information" do
      row "Purpose" do
        markdown.render(service.purpose).html_safe
      end
      row "How it works" do
        markdown.render(service.how_it_works).html_safe
      end
      row "Typical users" do
        markdown.render(service.typical_users).html_safe
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
          row :transactions_processed_applicable
          row :transactions_processed_with_intended_outcome_applicable
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

    panel "Versions" do
      table_for PaperTrail::Version.where(item_type: "Service", item_id: service.id).order('id desc') do
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

  form do |f|
    f.object.natural_key ||= SecureRandom.hex(2)
    f.inputs do
      f.input :name
      f.input :delivery_organisation
      f.input :owner
      f.input :natural_key
      f.input :other_name, as: :string, label: "Other transactions label"
      f.input :calls_other_name, as: :string, label: "Other calls label"
      f.input :purpose, as: :pagedown_text
      f.input :how_it_works, as: :pagedown_text
      f.input :typical_users, as: :pagedown_text
      f.input :start_page_url
      f.input :paper_form_url
      f.input :online_transactions_applicable
      f.input :phone_transactions_applicable
      f.input :paper_transactions_applicable
      f.input :face_to_face_transactions_applicable
      f.input :other_transactions_applicable
      f.input :transactions_processed_applicable
      f.input :transactions_processed_with_intended_outcome_applicable
      f.input :calls_received_applicable
      f.input :calls_received_get_information_applicable
      f.input :calls_received_chase_progress_applicable
      f.input :calls_received_challenge_decision_applicable
      f.input :calls_received_other_applicable
      f.input :calls_received_perform_transaction_applicable
      br
      f.input :sampled_calls
    end
    actions
  end

  batch_action :generate_links_for do |ids|
    @page_title = "Service publishing links"

    services = batch_action_collection.find(ids)

    @service_data = services.each_with_object({}) do |service, services_hash|
      dates = 5.times.each_with_object({}) do |count, hash|
        date = (Date.today - 2.month) + count.months
        month = YearMonth.new(date.year, date.month)
        hash[date] = MonthlyServiceMetricsPublishToken.generate(service: service, month: month)
      end
      services_hash[service] = dates
    end

    render "generate_magic_links"
  end

  permit_params :id, :natural_key, :name, :owner_id,
                :created_at, :updated_at, :delivery_organisation_id,
                :purpose, :how_it_works, :typical_users,
                :start_page_url, :paper_form_url,
                :online_transactions_applicable, :publish_token,
                :phone_transactions_applicable, :paper_transactions_applicable,
                :face_to_face_transactions_applicable, :other_transactions_applicable,
                :transactions_processed_applicable, :transactions_processed_with_intended_outcome_applicable,
                :calls_received_applicable, :calls_received_get_information_applicable,
                :calls_received_chase_progress_applicable, :calls_received_challenge_decision_applicable,
                :calls_received_other_applicable, :calls_received_perform_transaction_applicable,
                :other_name, :calls_other_name, :sampled_calls

  remove_filter :online_transactions_applicable, :phone_transactions_applicable,
                :paper_transactions_applicable,  :face_to_face_transactions_applicable,
                :other_transactions_applicable,  :transactions_processed_applicable,
                :transactions_processed_with_intended_outcome_applicable, :calls_received_applicable,
                :calls_received_get_information_applicable, :calls_received_chase_progress_applicable,
                :calls_received_challenge_decision_applicable, :calls_received_other_applicable,
                :calls_received_perform_transaction_applicable, :publish_token
end
