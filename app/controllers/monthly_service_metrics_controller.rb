class MonthlyServiceMetricsController < ApplicationController
  before_action :load_service, only: [:edit, :update]

  def edit
    @metrics = MonthlyServiceMetrics.new
    @metrics.service = @service
    @metrics.month = YearMonth.new(params[:year], params[:month])
  end

  def update
    @metrics = MonthlyServiceMetrics.new
    @metrics.service = @service
    @metrics.month = YearMonth.new(params[:year], params[:month])

    @metrics.attributes = params.require(:metrics).permit(:online_transactions,
      :phone_transactions, :paper_transactions, :face_to_face_transactions,
      :other_transactions, :transactions_with_outcome, :transactions_with_intended_outcome,
      :calls_received, :calls_received_get_information, :calls_received_chase_progress,
      :calls_received_challenge_decision, :calls_received_other).each {|_, value| value.gsub!(/\D/, '')}

    if @metrics.save
      render :success
    else
      render :edit
    end
  end

  private

  def load_service
    @service ||= Service.find(params[:service_id])
  end
end
