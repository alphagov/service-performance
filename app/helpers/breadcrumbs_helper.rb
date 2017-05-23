module BreadcrumbsHelper
  def breadcrumbs
    return '' if page.breadcrumbs.empty?

    items = page.breadcrumbs.map do |crumb|
      content_tag(:li, link_to(crumb.name, crumb.url))
    end

    list = content_tag(:ol, safe_join(items))

    content_tag(:div, list, class: 'breadcrumbs')
  end
end
