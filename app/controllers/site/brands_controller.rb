module Site
  class BrandsController < SiteController
    before_action :set_cache_headers
    def show
      id          = params[:slug].split("-")[0].to_i
      @brand      = Brand.find(id)
      @categories = Division.active_categories
      @skus       = Sku.active_skus.by_brand(id)
    end
  end
end
