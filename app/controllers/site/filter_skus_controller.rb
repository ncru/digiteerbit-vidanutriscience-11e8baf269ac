module Site
  class FilterSkusController < SiteController
    
    # POST /site/json/filter_skus
    # This method handles the AJAX filtering of products.
    def filter_skus
      # Decode the JSON String parameter passed by browser to 
      # a hash object to be able to read by Ruby.
      @hash = ActiveSupport::JSON.decode(params[:filters]) if params[:filters].present?
      
      if params[:slug].present? # Meaning coming from the brand page.
        id = params[:slug].split("-")[0].to_i
        @skus = Sku.active_skus.by_brand(id)
      else
        @skus = Sku.active_skus
      end
      
      @skus = @skus.reorder(@hash["order_by"]) if @hash["order_by"].present?
      
      # Process the supplied filters.
      @skus = @skus.where("p.brand_id IN (?)", @hash["brands"]) if @hash["brands"].present?
      @skus = @skus.where("p.sub_division_ids && ARRAY[?]", @hash["subcategories"]) if @hash["subcategories"].present?
    end
  end
end
