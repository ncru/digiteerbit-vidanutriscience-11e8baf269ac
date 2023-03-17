module Site
  class PrivacyPolicyController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      @privacy_policy = PrivacyPolicy.first
    end
  end
end
