module Admin
  class DhlProductsController < AdminController

    # GET /admin/dhl-products
    def index
      @dhl_products = DhlProduct.for_datatables
    end
    # PATCH /admin/dhl-products/:id
    # PUT /admin/dhl-products/:id
    def update
      @dhl_product = DhlProduct.find(params[:id])
      respond_to do |format|
        @dhl_product.update(dhl_product_params)
        format.js {render :status} 
      end
    end

    # POST /admin/datatables/retrieve_dhl_products
    def populate_datatables
      @dhl_products = build_datatable(DhlProduct.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @dhl_products }
      end
    end
    
    private
      def dhl_product_params
        params.require(:dhl_product).permit(:status)
      end

  end
end
