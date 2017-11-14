ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recently added metrics" do
          ul do
            MonthlyServiceMetrics.last(10).reverse.map do |metric|
              k = "#{metric.month} - #{metric.service.name}"
              li link_to(k, admin_monthly_service_metric_path(metric))
            end
          end
        end
      end
    end
  end
end
