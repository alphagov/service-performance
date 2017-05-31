class Page
  def initialize
    @breadcrumbs = []
  end

  attr_reader :breadcrumbs
  attr_writer :title

  def title
    if @title.present?
      "#{@title} - Cross-Government Service Data"
    else
      'Cross-Government Service Data'
    end
  end

  def url
    nil
  end

end
