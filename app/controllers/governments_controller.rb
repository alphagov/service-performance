class GovernmentsController < ApplicationController
  def show
    government = Government.new
    render json: government
  end
end
