class MonthlyServiceMetricsController < PublishDataController
  before_action :load_service, only: %i(edit update)
  before_action :load_metrics, only: %i(edit update)

  skip_authentication

  def edit; end

  def update
    @metrics.attributes = params.require(:metrics).permit(:online_transactions,
      :phone_transactions, :paper_transactions, :face_to_face_transactions,
      :other_transactions, :transactions_with_outcome, :transactions_with_intended_outcome,
      :calls_received, :calls_received_perform_transaction, :calls_received_get_information,
      :calls_received_chase_progress, :calls_received_challenge_decision,
      :calls_received_other).each { |_, value| value.gsub!(/\D/, '') }

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

  def load_metrics
    month = YearMonth.new(params[:year], params[:month])
    @metrics = MonthlyServiceMetrics.where(service: @service, month: month).first_or_initialize

    unless MonthlyServiceMetricsPublishToken.valid?(token: params[:publish_token], metrics: @metrics)
      render 'invalid_publish_token', status: :unauthorized
      return
    end
  end
end
