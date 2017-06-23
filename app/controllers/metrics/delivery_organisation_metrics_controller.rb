class DeliveryOrganisationMetricsController < ApplicationController
  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = DeliveryOrganisationMetricsPresenter.new(client: client, delivery_organisation: params[:delivery_organisation_id], group_by: params[:group_by])
    render 'metrics/index'
  end
end
