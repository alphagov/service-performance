module FormHelper
  class MonthlyServiceMetricsFormBuilder < ActionView::Helpers::FormBuilder
    def metric(name)
      label = I18n.translate(name, scope: ['helpers', 'label', 'monthly_service_metrics'])

      @template.content_tag(:div, class: 'form-group') do
        label(name, label, class: 'form-label') + number_field(name, class: 'form-control form-control-1-4')
      end
    end
  end
end
