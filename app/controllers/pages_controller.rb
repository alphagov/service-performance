class PagesController < ApplicationController
  def homepage
    page.display_header_border = false
  end
end
