class DepartmentsController < ApplicationController
  def show
    department = Department.where(natural_key: params[:id]).first!
    render json: department
  end
end
