class DeliveryOrganisationsController < ApplicationController
  def show
    delivery_organistion = DeliveryOrganisation.where(natural_key: params[:id]).first!
    render json: delivery_organistion
  end
end
