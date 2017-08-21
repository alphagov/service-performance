require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  it "displays the 500 page" do
    get :internal_server_error
    expect(controller).to have_rendered('errors/internal_server_error')
  end

  it "displays the 404 page" do
    get :not_found
    expect(controller).to have_rendered('errors/not_found')
  end
end
