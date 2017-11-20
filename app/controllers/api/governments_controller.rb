module Api
  class GovernmentsController < APIController
    def show
      government = Government.new
      render json: government
    end
  end
end
