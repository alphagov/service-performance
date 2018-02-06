module ViewData
  class PagesController < ViewDataController
    def homepage
      page.display_header_border = false
    end

    def how_to_use; end

    def transactions_processed_help; end

    def transactions_received_help; end

    def calls_received_help; end

    def cookies; end

    def privacy; end

    def terms; end
  end
end
