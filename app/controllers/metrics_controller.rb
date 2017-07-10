class MetricsController < ApplicationController
  private

  def client
    @client ||= CrossGovernmentServiceDataAPI::Client.new
  end

  def group_by
    params[:group_by]
  end

  def order
    params.fetch(:filter, {})[:order]
  end

  def order_by
    params.fetch(:filter, {})[:order_by]
  end
end
