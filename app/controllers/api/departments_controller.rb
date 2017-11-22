module Api
  class DepartmentsController < APIController
    def show
      department = Department.where(natural_key: params[:id]).first!
      render json: department
    end
  end
end
