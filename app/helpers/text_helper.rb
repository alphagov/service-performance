module TextHelper
  def pluralize_link(count, singular, plural, url)
    text = pluralize(count, singular, plural)
    link_to(text, url)
  end
end
