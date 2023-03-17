module Site
  class ContactUsController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @message = Message.new
    end
  end
end
