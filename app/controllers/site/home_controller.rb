module Site
  class HomeController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @sliders               = Slider.homepage_sliders
      @brands                = Brand.active_brands
      @featured_skus         = Sku.featured_skus
      @advertisements        = Advertisement.active_advertisements
      @newsletter_subscriber = NewsletterSubscriber.new
    end
  end
end
