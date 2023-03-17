module Site
  class FaqsController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @faqs = Faq.active_faqs
    end
  end
end
