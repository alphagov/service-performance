module ServicesHelper
  def render_markdown(field)
    return '' if !field

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    markdown.render(field).html_safe
  end
end
