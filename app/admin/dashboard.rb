ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    h2 "Recently added"
    columns do
      column do
        panel "Recently added metrics" do
          table do
            tr do
              th "Month"
              th "Delivery Organisation"
              th "Service"
              th "Updated"
            end
            MonthlyServiceMetrics.last(10).reverse.map do |metric|
              tr do
                td metric.month
                td metric.service.delivery_organisation.name
                td link_to(metric.service.name, admin_monthly_service_metric_path(metric))
                td metric.updated_at.to_date
              end
            end
          end
        end
      end

      column do
        panel "Recently added services" do
          table do
            tr do
              th "Delivery Organisation"
              th "Added"
              th "Service"
            end
            Service.last(10).reverse.map do |svc|
              tr do
                td svc.delivery_organisation.name
                td svc.created_at.to_date
                td link_to(svc.name, admin_service_path(svc))
              end
            end
          end
        end
      end
    end

    h2 "Recent audit items"
    section "" do
      table_for PaperTrail::Version.order('id desc').limit(20) do
        column"Item", :item
        column("Type") { |v| v.item_type.underscore.humanize }
        column("Modified at") { |v| v.created_at.to_s :long }
        column("Admin") { |v|
          if v.whodunnit.in? ["Unknown user", nil]
            "Unknown user"
          else
            link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)]
          end
        }
      end
    end
  end
end
