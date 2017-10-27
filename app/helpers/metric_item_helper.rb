module MetricItemHelper
  include GovernmentServiceDataAPI::MetricStatus
  #include Metrics::Items

  def metric_item(metric_item, metric_value, sampled: false, html: {})
    return if metric_value == NOT_APPLICABLE

    item = MetricItemContent.new(self, metric_value)
    content = capture { yield(item) } || ''

    guidance = translate(:description_html, default: :description, scope: ['metric_guidance', metric_item.identifier]) if guidance?(metric_item)

    html[:data] ||= {}
    html[:data].merge!('metric-item-identifier' => metric_item.identifier, 'metric-item-description' => item.description.try(:strip), 'metric-item-guidance' => guidance)

    html[:class] = Array.wrap(html[:class])
    html[:class] << 'sampled' if sampled

    if guidance?(metric_item)
      content += content_tag(:span, class: 'm-metric-guidance-toggle') do
        content_tag(:a, '+', href: '#', class: 'a-metric-guidance-expand', data: { behaviour: 'a-metric-guidance-toggle' })
      end
    end

    row = content_tag(:div, content, class: 'row')
    content_tag(:li, row, html)
  end

  def guidance?(metric_item)
    metric_item.in? %w[Metrics::Items::CallsReceived Metrics::Items::TransactionsEndingInOutcome Metrics::Items::TransactionsReceived]
  end


  class MetricItemContent < ActionView::Base
    include GovernmentServiceDataAPI::MetricStatus
    include MetricFormatterHelper

    def initialize(helper, metric_value)
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

    def incomplete(completeness)
      return '' if !completeness
      if completeness.values.any? { |item| item['actual'] != item['expected'] }
        content_tag(:div, 'Based on incomplete data', class: 'metric-subheading-grey')
      end
    end

    def completeness(scores)
      return '' if !scores || @metric_value.in?([NOT_PROVIDED, NOT_APPLICABLE])

      actual = scores['actual']
      expected = scores['expected']

      return '' if actual == expected

      content = "Data provided for #{actual} of #{expected} months".html_safe
      content_tag(:div, content, class: 'metric-text-grey')
    end

    def description(&content)
      return @description if [NOT_PROVIDED, NOT_APPLICABLE].include? @metric_value

      if content
        @description = @helper.capture(&content)
      else
        @description
      end
    end
  end
end
