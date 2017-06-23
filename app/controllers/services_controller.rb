class ServicesController < ApplicationController

  def show
    client = CrossGovernmentServiceDataAPI::Client.new
    @service = client.service(params[:id])

    page.title = @service.name
  end

end
