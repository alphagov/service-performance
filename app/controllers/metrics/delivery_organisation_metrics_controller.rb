class DeliveryOrganisationMetricsController < ApplicationController
  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = DeliveryOrganisationMetricsPresenter.new(client: client, delivery_organisation: params[:delivery_organisation_id], group: params[:group])
    render 'metrics/index'
  end
end
