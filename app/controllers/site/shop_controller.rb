module Site
  class ShopController < SiteController    
    before_action :set_cache_headers, only: [:index]
    def index
      @skus       = Sku.active_skus
      @categories = Division.active_categories
      @brands     = Brand.active_brands
    end

    def show
      id                 = params[:slug].split("-")[0].to_i
      @product           = Product.find(id)
      @product_review    = ProductReview.new
      @skus              = Sku.get_product_skus(id)
      @selected_sku      = params[:sku].present? ? @skus.where("s.id = ?", params[:sku]).first : @skus.first
      @recommended_items = Sku.related_items_by_brand(@product.brand_id, @selected_sku.id)
      @faqs              = @product.product_faqs
    end
  end
end
