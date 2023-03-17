module Admin
  class ProductsController < AdminController
    
    before_action :set_cors,    only: [:new, :edit]
    before_action :set_lookups, only: [:index, :new, :edit]
    before_action :set_product, only: [:edit, :update, :destroy]

    # GET /admin/products
    def index
      @products = Product.for_datatables
    end

    # GET /admin/products/new
    def new
      @product = Product.new
      @sub_categories = []
    end

    # POST /admin/products
    def create
      @product_params = product_params
      handle_inventory_update
      handle_price_update
      @product = Product.new(@product_params)
      if @product.save
        log_to_audittrail('add', 'PRODUCT', @product.name)

        redirect_to admin_products_path, notice: "<strong>" + @product.name + "</strong> has been successfully added."
      else
        set_cors
        set_lookups
        @sub_categories = []
        render :new
      end
    end

    # GET /admin/products/:id/edit
    def edit
      @sub_categories = SubDivision.active_sub_categories(@product.division_id)
    end

    # PATCH /admin/products/:id
    # PUT /admin/products/:id
    def update
      @product_params = product_params
      handle_price_update
      handle_inventory_update
      if @product.update(@product_params)
        process_sku_photos
        log_to_audittrail('edit', 'PRODUCT', @product.name)

        redirect_to admin_products_path, notice: "<strong>" + @product.name + "</strong> has been successfully updated."
      else
        set_cors
        set_lookups
        @sub_categories = SubDivision.active_sub_categories(@product.division_id)
        render :edit
      end
    end

    # DELETE /admin/products/:id
    def destroy
      @product.destroy

      flash[:notice] = "<strong>" + @product.name + "</strong> has been successfully removed."
      log_to_audittrail('delete', 'PRODUCT', @product.name)

      flash.discard if Product.for_datatables.count(1) == 0

      redirect_to admin_products_path
    end

    # POST /admin/datatables/retrieve_products
    def populate_datatables
      @products = build_datatable(Product.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @products }
      end
    end
    
    # This method retrieves all the sub categories under a specific category.
    def retrieve_sub_categories
      @sub_categories = SubDivision.active_sub_categories(product_params[:division_id])
      
      # Return the states.
      respond_to do |format|
        format.json  { 
          render :json => {:sub_categories => @sub_categories}
        }
      end
    end

    private
      def product_params
        params.require(:product).permit(:name, :description, :status, :new, :featured, {tags: []}, :photos, :photo_url, :brand_id, :division_id, {sub_division_ids: []}, {restricted_country_codes: []}, :long_description, :size, :dimensions, :weight, :ingredients, :policy, :background_photo, :photo, skus_attributes: [:id, :code, :name, :minimum_quantity, :weight, :status, :new, :featured, {photos: []}, {tags: []}, :_destroy, inventory_items_attributes: [:id, :sku_id, :action_id, :quantity, :inventory_id], price_update_items_attributes: [:id, :sku_id, :price, :price_update_id]], product_faqs_attributes: [:id, :title, :question, :answer, :status, :_destroy])
      end

      # Set the value of @product.
      def set_product
        @product = Product.find(params[:id])
      end

      # Populate the values of the lookups.
      def set_lookups
        @categories    = Division.for_select_items
        @brands        = Brand.for_select_items
        @countries     = Country.active_countries_from_shipping
      end

      # Remove the SKU photos if not present in the parameters.
      # This needs to be manually processed because of the design
      # of adding photos to the SKU.
      def process_sku_photos
        product_params[:skus_attributes].each do |index|
          sku_attribute = product_params[:skus_attributes][index]
          if sku_attribute[:photos].nil? && sku_attribute[:id].present?
            sku = @product.skus.find(sku_attribute[:id])
            sku.delete_photos if sku.present?
          end
        end
      end
      
      def handle_inventory_update
        latest_inventory = Inventory.latest_today(current_user.id)
        if latest_inventory.present?
          inventory_id = latest_inventory.first.id
        else
          inventory =  Inventory.create(user_id: current_user.id)
          inventory_id = inventory.id
        end
        @product_params[:skus_attributes].each do |index|
          if (@product_params[:skus_attributes][index])[:inventory_items_attributes].present?
            @product_params[:skus_attributes][index][:inventory_items_attributes].each do |index2|
              @product_params[:skus_attributes][index][:inventory_items_attributes][index2][:inventory_id] = inventory_id
            end
          end
        end
      end
      
      def handle_price_update
        price_update =  PriceUpdate.create(price_type: 0, start_date: Date.today, has_no_end_date: 1, user_id: current_user.id)
        price_update_id = price_update.id
        @product_params[:skus_attributes].each do |index|
          @product_params[:skus_attributes][index][:price_update_items_attributes].each do |index2|
            @product_params[:skus_attributes][index][:price_update_items_attributes][index2][:price_update_id] = price_update_id
          end
        end
      end
  end
end
