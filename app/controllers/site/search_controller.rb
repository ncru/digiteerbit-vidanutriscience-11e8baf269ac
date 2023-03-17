module Site
  class SearchController < SiteController
    before_action :set_cache_headers, only: [:index]
    def index
      unless params[:q].present? 
        redirect_to root_path and return
      end
      
      @skus = Sku.search(params[:q])
    end
  end
end
