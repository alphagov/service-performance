class ServicesController < ApplicationController

  def show
    client = CrossGovernmentServiceDataAPI::Client.new
    @service = client.service(params[:id])

    @metrics = ServiceMetricsPresenter.new(@service, client: client, group_by: Metrics::Group::Service)

    page.title = @service.name
  end

end
