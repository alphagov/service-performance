class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

private

  helper_method :page
  def page
    @page ||= Page.new(self)
  end
end
