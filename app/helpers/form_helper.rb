module FormHelper
  class MonthlyServiceMetricsFormBuilder < ActionView::Helpers::FormBuilder
    def fieldset(heading, &block)
      heading = @template.content_tag(:h2, heading, class: 'bold-medium')
      fields = @template.capture(&block)

      if fields.present?
        @template.content_tag(:fieldset, heading + fields)
      end
    end

    def metric(name, applicable: true)
      return '' unless applicable

      label = I18n.translate(name, scope: %w(helpers label monthly_service_metrics))

      @template.content_tag(:div, class: 'form-group') do
        label(name, label, class: 'form-label') + number_field(name, class: 'form-control form-control-1-4')
      end
    end
  end
end
