module MetricItemHelper
  def metric_item(metric_item, metric_value, sampled: false, html: {})
    return if metric_value == Metric::NOT_APPLICABLE
    item = MetricItemContent.new(self, metric_value)
    content = capture { yield(item) } || ''

    guidance = translate(:description_html, default: :description, scope: ['metric_guidance', metric_item.identifier]) if item.display_guidance?

    html[:data] ||= {}
    html[:data].merge!('metric-item-identifier' => metric_item.identifier, 'metric-item-description' => item.description.try(:strip), 'metric-item-guidance' => guidance)

    html[:class] = Array.wrap(html[:class])
    html[:class] << 'sampled' if sampled

    if item.display_guidance?
      content += content_tag(:span, class: 'm-metric-guidance-toggle') do
        id_text = "guidance-#{metric_item.identifier}"
        content_tag(:a, '+', id: id_text, href: '#', class: 'a-metric-guidance-expand', data: { behaviour: 'a-metric-guidance-toggle' })
      end
    end

    row = content_tag(:div, content, class: 'row')
    content_tag(:li, row, html)
  end

  class MetricItemContent < ActionView::Base
    include MetricFormatterHelper

    def initialize(helper, metric_value)
      @helper = helper || self
      @metric_value = metric_value
    end

    def value
      return content_tag(:span, 'Not provided', class: 'metric-value-not-provided') if @metric_value == Metric::NOT_PROVIDED

      val = metric_to_human(@metric_value)
      content_tag(:span, val, class: 'metric-value-count')
    end

    def percentage(pct)
      return '' if pct.in? [Metric::NOT_PROVIDED, Metric::NOT_APPLICABLE]

      percentage_string = metric_to_percentage(pct)
      content_tag(:span, "(#{percentage_string})", class: 'metric-value-percentage')
    end

    def incomplete(completeness)
      if completeness.values.any?(&:incomplete?)
        content_tag(:div, 'Based on incomplete data', class: 'metric-subheading-grey')
      end
    end

    def completeness(completeness)
      return '' if !completeness || @metric_value.in?([Metric::NOT_PROVIDED, Metric::NOT_APPLICABLE])
      return '' if completeness.complete?

      content = "Data provided for #{completeness.actual} of #{completeness.expected} months"
      content_tag(:div, content, class: 'metric-text-grey')
    end

    def description(&content)
      return @description if [Metric::NOT_PROVIDED, Metric::NOT_APPLICABLE].include? @metric_value

      if content
        @description = @helper.capture(&content)
      else
        @description
      end
    end

    attr_writer :display_guidance

    def display_guidance?
      @display_guidance ? true : false
    end
  end
end
