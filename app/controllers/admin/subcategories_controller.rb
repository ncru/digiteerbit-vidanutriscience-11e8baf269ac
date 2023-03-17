module Admin
  class SubcategoriesController < AdminController

    before_action :set_subcategory, only: [:edit, :update, :destroy]
    before_action :set_lookups, only: [:index, :new, :edit, :show]

    # GET /admin/subcategories
    def index
      @sub_categories = SubDivision.for_datatables
    end

    # GET /admin/subcategories/new
    def new
      @sub_category = SubDivision.new
    end

    # POST /admin/subcategories
    def create
      @sub_category = SubDivision.new(subcategory_params)

      if @sub_category.save
        log_to_audittrail('add', 'SUBCATEGORY', @sub_category.name)

        redirect_to admin_subcategories_path, notice: "Sub Category <strong>" + @sub_category.name + "</strong> has been successfully added."
      else
        set_lookups
        render :new
      end
    end

    # GET /admin/subcategories/:id/edit
    def edit
    end

    # PATCH /admin/subcategories/:id
    # PUT /admin/subcategories/:id
    def update
      if @sub_category.update(subcategory_params)
        log_to_audittrail('edit', 'SUBCATEGORY', @sub_category.name)

        redirect_to admin_subcategories_path, notice: "Sub Category <strong>" + @sub_category.name + "</strong> has been successfully updated."
      else
        set_lookups
        render :edit
      end
    end

    # DELETE /admin/subcategories/:id
    def destroy
      @sub_category.destroy
      
      flash[:notice] = "Sub Category <strong>" + @sub_category.name + "</strong> has been successfully removed."
      log_to_audittrail('delete', 'SUBCATEGORY', @sub_category.name)

      flash.discard if SubDivision.for_datatables.count(1) == 0

      redirect_to admin_subcategories_path
    end

    # POST /admin/datatables/retrieve_subcategories
    def populate_datatables
      @sub_categories = build_datatable(SubDivision.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @sub_categories }
      end
    end

    private
      def subcategory_params
        params.require(:sub_division).permit(:name, :status, :division_id)
      end

      def set_subcategory
        @sub_category = SubDivision.find(params[:id])
      end
      
      def set_lookups
        @categories = Division.active_categories
      end
  end
end
