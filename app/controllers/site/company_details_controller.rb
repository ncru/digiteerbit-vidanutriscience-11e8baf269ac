module Site
  class CompanyDetailsController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @company_details = CompanyDetail.first
    end
  end
end
