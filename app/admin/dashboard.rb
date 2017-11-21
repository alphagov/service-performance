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
  end
end
