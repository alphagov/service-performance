module ViewData
  class PagesController < ViewDataController
    def homepage
      page.display_header_border = false
    end

    def how_to_use
    end
  end
end
