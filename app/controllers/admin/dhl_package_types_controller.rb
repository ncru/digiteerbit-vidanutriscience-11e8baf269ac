module Admin
  class DhlPackageTypesController < AdminController

    # GET /admin/dhl-package-types
    def index
      @dhl_package_types = DhlPackageType.for_datatables
    end
    # PATCH /admin/dhl-package-types/:id
    # PUT /admin/dhl-package-types/:id
    def update
      @dhl_package_type = DhlPackageType.find(params[:id])
      respond_to do |format|
        @dhl_package_type.update(dhl_package_type_params)
        format.js {render :status} 
      end
    end

    # POST /admin/datatables/retrieve_dhl_package_types
    def populate_datatables
      @dhl_package_types = build_datatable(DhlPackageType.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @dhl_package_types }
      end
    end
    
    private
      def dhl_package_type_params
        params.require(:dhl_package_type).permit(:status)
      end

  end
end
