module PublishData
  class PagesController < PublishDataController
    skip_authentication

    def service_manual; end

    def transactions_received; end
  end
end
