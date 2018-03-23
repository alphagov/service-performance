module PublishData
  class MonthlyServiceMetricsController < PublishDataController
    before_action :load_service, only: %i(edit update preview)
    before_action :load_metrics, only: %i(edit update preview)

    skip_authentication

    def edit; end

    def update
      @monthly_service_metrics.attributes = params.require(:metrics).permit(:online_transactions,
        :phone_transactions, :paper_transactions, :face_to_face_transactions,
        :email_transactions, :other_transactions, :transactions_processed,
        :transactions_processed_with_intended_outcome,
        :calls_received, :calls_received_perform_transaction, :calls_received_get_information,
        :calls_received_chase_progress, :calls_received_challenge_decision,
        :calls_received_other).each { |_key, value| value.gsub!(/\D/, '') }

      begin
        svc = @monthly_service_metrics.service
        svc.attributes = params.require(:services).permit(:other_name, :calls_other_name).each { |_, value| value }
        svc.save
      rescue => _e
        # It's possible that the :services fields are not set as they are not relevant
        # so we will allow them to fail here.
        logger.info("Metrics provided with no detail for other labels")
      end

      if @monthly_service_metrics.save
        render 'publish_data/monthly_service_metrics/success'
      else
        render 'publish_data/monthly_service_metrics/edit'
      end
    end

    def preview
      @metrics = PreviewMetricsPresenter.new(@monthly_service_metrics)
    end

  private

    def load_service
      @service ||= Service.where('id = :id OR natural_key = :id', id: params[:service_id]).first!
    end

    def load_metrics
      month = YearMonth.new(params[:year], params[:month])
      @monthly_service_metrics = MonthlyServiceMetrics.where(service: @service, month: month).first_or_initialize

      unless MonthlyServiceMetricsPublishToken.valid?(token: params[:publish_token], metrics: @monthly_service_metrics)
        render 'publish_data/monthly_service_metrics/invalid_publish_token', status: :unauthorized
        return
      end
    end
  end
end
