class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include AuthenticatedController

private

  helper_method :page
  def page
    @page ||= Page.new(self)
  end
end
