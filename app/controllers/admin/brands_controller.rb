module Admin
  class BrandsController < AdminController

    before_action :set_cors, only: [:edit, :new]
    before_action :set_brand, only: [:edit, :update, :destroy]

    # GET /admin/brands
    def index
      @brands = Brand.for_datatables
    end

    # GET /admin/brands/new
    def new
      @brand = Brand.new
    end

    # POST /admin/brands
    def create
      @brand = Brand.new(brand_params)

      respond_to do |format|
        if @brand.save
          log_to_audittrail('add', 'BRAND', @brand.name)

          format.html {
            redirect_to admin_brands_path, notice: "Brand <strong>" + @brand.name + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/brands/:id/edit
    def edit
    end

    # PATCH /admin/brands/:id
    # PUT /admin/brands/:id
    def update
      respond_to do |format|
        if @brand.update(brand_params)
          log_to_audittrail('edit', 'BRAND', @brand.name)

          format.html {
            redirect_to admin_brands_path, notice: "Brand <strong>" + @brand.name + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/brands/:id
    def destroy
      @brand.destroy

      respond_to do |format|
        flash[:notice] = "Brand <strong>" + @brand.name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'BRAND', @brand.name)

        flash.discard if Brand.for_datatables.count(1) == 0

        format.html { redirect_to admin_brands_path }
      end
    end

    # POST /admin/datatables/retrieve_brands
    def populate_datatables
      @brands = build_datatable(Brand.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @brands }
      end
    end

    private
      def brand_params
        params.require(:brand).permit(:name, :description, :status, :photo_url, :banner_photo_url)
      end

      def set_brand
        @brand = Brand.find(params[:id])
      end
  end
end
