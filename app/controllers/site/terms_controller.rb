module Site
  class TermsController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @terms = Term.first
    end
  end
end
