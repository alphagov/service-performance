class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit

  include AuthenticatedController

private

  helper_method :page
  def page
    @page ||= Page.new(self)
  end

protected

  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user.try(:id) : nil
  end
end
