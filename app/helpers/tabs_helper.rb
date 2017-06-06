module TabsHelper
  def tabs(current_page:)
    tabs = Tabs.new
    yield tabs

    return '' if tabs.links.empty?

    tab_links = tabs.links.map do |(name, url)|
      selected = current_page.path == URI(url).path

      classes = ['m-tab-item']
      classes << 'm-tab-item__selected' if selected

      content_tag(:li, class: classes) do
        link_to(name, url, class: 'm-tab-link')
      end
    end

    content_tag(:nav, class: 'o-tabs grid-row') do
      content_tag(:ol, safe_join(tab_links))
    end
  end

  def tab_name(name, count: nil)
    return name unless count

    count_tag = content_tag(:span, "(#{count})", class: 'count')
    safe_join([name, count_tag], ' ')
  end

  private

  class Tabs
    def initialize
      @links = []
    end

    attr_reader :links

    def link_to(name, url)
      @links << [name, url]
    end
  end
end
