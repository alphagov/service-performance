class PagesController < ApplicationController
  skip_authentication

  def homepage
    page.display_header_border = false
  end

  def service_manual() end
end
