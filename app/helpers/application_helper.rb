module ApplicationHelper
  def get_port
    return "" if request.port.in? [80, 443]
    ":#{request.port}"
  end

  def absolute_url(url)
    "#{request.protocol}#{request.host}#{get_port}#{url}"
  end
end
