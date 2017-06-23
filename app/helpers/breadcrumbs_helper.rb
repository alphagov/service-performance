module BreadcrumbsHelper
  def breadcrumbs(inverse: false)
    return '' if page.breadcrumbs.empty?

    items = page.breadcrumbs.map do |crumb|
      name = content_tag(:span, crumb.name, itemprop: 'name')
      link = link_to(name, crumb.url, itemprop: 'item')
      content_tag(:li, link, class: 'breadcrumbs__item', itemscope: 'itemscope', itemtype: 'http://schema.org/ListItem', itemprop: 'itemListElement')
    end

    list = content_tag(:ol, safe_join(items), itemscope: 'itemscope', itemtype: 'http://schema.org/BreadcrumbList')

    nav_classes = ['breadcrumbs']
    nav_classes << 'breadcrumbs--inverse' if inverse
    content_tag(:nav, list, class: nav_classes, 'aria-label': 'Breadcrumbs')
  end
end
