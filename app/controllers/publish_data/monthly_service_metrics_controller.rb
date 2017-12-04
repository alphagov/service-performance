module PublishData
  class MonthlyServiceMetricsController < PublishDataController
    before_action :load_service, only: %i(edit update preview)
    before_action :load_metrics, only: %i(edit update preview)

    skip_authentication

    def edit; end

    def update
      @metrics.attributes = params.require(:metrics).permit(:online_transactions,
        :phone_transactions, :paper_transactions, :face_to_face_transactions,
        :other_transactions, :transactions_processed, :transactions_processed_with_intended_outcome,
        :calls_received, :calls_received_perform_transaction, :calls_received_get_information,
        :calls_received_chase_progress, :calls_received_challenge_decision,
        :calls_received_other).each { |_, value| value.gsub!(/\D/, '') }

      if @metrics.save
        render 'publish_data/monthly_service_metrics/success'
      else
        render 'publish_data/monthly_service_metrics/edit'
      end
    end

    class PreviewMetrics < Metrics
      class TimePeriod
        def initialize(month)
          @month = month
        end

        def months
          [@month]
        end

        def starts_on
          @month.starts_on
        end

        def ends_on
          @month.ends_on
        end
      end

      def initialize(monthly_service_metrics)
        @monthly_service_metrics = monthly_service_metrics
        @time_period = PreviewMetrics::TimePeriod.new(@monthly_service_metrics.month)
      end

      def entities
        [service]
      end

      def published_monthly_service_metrics(_ = nil)
        [@monthly_service_metrics]
      end

      attr_reader :time_period

      def service
        @monthly_service_metrics.service
      end
    end

    def preview
      @monthly_service_metrics = monthly_service_metrics = @metrics
      @presenter = MetricsPresenter.new(@service, group_by: Metrics::GroupBy::Service)

      @data = data = PreviewMetrics.new(monthly_service_metrics)
      @presenter.send(:define_singleton_method, :data) do
        data
      end

      @metrics = @presenter
    end

  private

    def load_service
      @service ||= Service.where('id = :id OR natural_key = :id', id: params[:service_id]).first!
    end

    def load_metrics
      month = YearMonth.new(params[:year], params[:month])
      @metrics = MonthlyServiceMetrics.where(service: @service, month: month).first_or_initialize

      unless MonthlyServiceMetricsPublishToken.valid?(token: params[:publish_token], metrics: @metrics)
        render 'publish_data/monthly_service_metrics/invalid_publish_token', status: :unauthorized
        return
      end
    end
  end
end
