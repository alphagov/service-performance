module MetricItemHelper
  include GovernmentServiceDataAPI::MetricStatus

  def metric_item(identifier, sampled: false, metric_value: nil, html: {})
    return if metric_value == NOT_APPLICABLE

    item = MetricItem.new(self, metric_value)
    content = capture { yield(item) } || ''

    guidance = translate("metric_guidance.#{identifier}.description")

    html[:data] ||= {}
    html[:data].merge!('metric-item-identifier' => identifier, 'metric-item-description' => item.description.try(:strip), 'metric-item-guidance' => guidance)

    html[:class] = Array.wrap(html[:class])
    html[:class] << 'sampled' if sampled

    content += content_tag(:span, class: 'm-metric-guidance-toggle') do
      content_tag(:a, '+', href: '#', class: 'a-metric-guidance-expand', data: { behaviour: 'a-metric-guidance-toggle' })
    end

    row = content_tag(:div, content, class: 'row')
    content_tag(:li, row, html)
  end


  class MetricItem < ActionView::Base
    include GovernmentServiceDataAPI::MetricStatus
    include MetricFormatterHelper

    def initialize(helper = nil, metric_value = nil)
      @helper = helper || self
      @metric_value = metric_value
    end

    def value
      return content_tag(:span, 'Not provided', class: 'metric-value-not-provided') if @metric_value == NOT_PROVIDED

      val = metric_to_human(@metric_value)
      content_tag(:span, val, class: 'metric-value-count')
    end

    def percentage(pct)
      return '' if pct.in? [NOT_PROVIDED, NOT_APPLICABLE]

      percentage_string = metric_to_percentage(pct)
      content_tag(:span, "(#{percentage_string})", class: 'metric-value-percentage')
    end

    def description(&content)
      if [NOT_PROVIDED, NOT_APPLICABLE].include? @metric_value
        return @description = "Erm"
      end

      if content
        @description = @helper.capture(&content)
      else
        @description
      end
    end
  end
end
