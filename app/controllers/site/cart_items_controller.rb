module Site
  class CartItemsController < SiteController

    before_action :set_cart_item, only: [:update, :destroy]

    def create
      @cart_item = @cart.add_item(cart_item_params)
      @cart_item.save
      
      @skus = Sku.find(cart_item_params[:sku_id]).product.skus
    end

    def update
      @cart.update_item(@cart_item, params[:method])
    end

    def destroy
      @skus = @cart_item.sku.product.skus
      
      @cart_item.destroy
    end

    private
      def cart_item_params
        params.require(:cart_item).permit(:quantity, :sku_id, :method)
      end

      def set_cart_item
        @cart_item = @cart.cart_items.find(params[:id])
      end
  end
end
