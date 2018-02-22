module FormHelper
  class MonthlyServiceMetricsFormBuilder < ActionView::Helpers::FormBuilder
    def fieldset(heading, &block)
      heading = @template.content_tag(:h2, heading, class: 'bold-medium')
      fields = @template.capture(&block)

      if fields.present?
        @template.content_tag(:fieldset, heading + fields)
      end
    end

    def metric_label(name, applicable: true, label: nil, extra: nil)
      return '' unless applicable

      label = label || I18n.translate(name, scope: %w(helpers label monthly_service_metrics))
      @template.content_tag(:div) do
        content = label(name, label.capitalize, class: 'form-label')
        if extra
          content += @template.content_tag(:span, extra, class: "form-hint")
        end
        content
      end
    end

    def metric_number_field(name, applicable: true, error: nil)
      return '' unless applicable

      @template.content_tag(:div) do
        content = number_field(name, class: error.nil? ? 'form-control form-control-1-4' : 'form-control-error')
        content
      end
    end

    def metric(name, applicable: true, label: nil, extra: nil, error: nil)
      return '' unless applicable

      label = label || I18n.translate(name, scope: %w(helpers label monthly_service_metrics))

      @template.content_tag(:div, class: error.nil? ? 'form-group' : 'form-group-error') do
        content = label(name, label.capitalize, class: 'form-label')
        field_content = number_field(name, class: error.nil? ? 'form-control form-control-1-4' : 'form-control-error')

        if extra
          content += @template.content_tag(:span, extra, class: "form-hint")
        end
        content += field_content
        content
      end
    end
  end
end
