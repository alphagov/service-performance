class Page
  class Crumb
    def initialize(name, url = nil)
      @name = name
      @url = url
    end

    attr_reader :name, :url
  end

  def initialize(controller)
    @controller = controller
    @breadcrumbs = []
    @display_header_border = true
  end

  attr_accessor :display_header_border
  attr_reader :breadcrumbs
  attr_writer :title

  def title
    if @title.present?
      "#{@title} - Service Performance"
    else
      'Service Performance'
    end
  end

  def path
    @controller.request.path
  end
end
