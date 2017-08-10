module MetricItemHelper
  def metric_item(identifier, sampled: false, html: {}, &block)
    item = MetricItem.new(self)
    content = capture { block.call(item) } || ''

    guidance = translate("metric_guidance.#{identifier}.description")

    html[:data] ||= {}
    html[:data].merge!('metric-item-identifier' => identifier, 'metric-item-description' => item.description.try(:strip), 'metric-item-guidance' => guidance)

    html[:class] = Array.wrap(html[:class])
    html[:class] << 'sampled' if sampled

    
    content += content_tag(:span, class: 'm-metric-guidance-toggle') do
      content_tag(:a, '+', href: '#', class: 'a-metric-guidance-expand', data: {behaviour: 'a-metric-guidance-toggle'})
    end

    row = content_tag(:div, content, class: 'row')
    content_tag(:li, row, html)
  end

  private

  class MetricItem < ActionView::Base
    def initialize(helper = nil)
      @helper = helper || self
    end

    def description(&content)
      if content
        @description = @helper.capture(&content)
      else
        @description
      end
    end
  end
end
