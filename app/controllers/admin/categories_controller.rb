module Admin
  class CategoriesController < AdminController

    before_action :set_category, only: [:edit, :update, :destroy]

    # GET /admin/categories
    def index
      @categories = Division.for_datatables
    end

    # GET /admin/categories/new
    def new
      @category = Division.new
    end

    # POST /admin/categories
    def create
      @category = Division.new(category_params)

      respond_to do |format|
        if @category.save
          log_to_audittrail('add', 'CATEGORY', @category.name)

          format.html {
            redirect_to admin_categories_path, notice: "Category <strong>" + @category.name + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/categories/:id/edit
    def edit
    end

    # PATCH /admin/categories/:id
    # PUT /admin/categories/:id
    def update
      respond_to do |format|
        if @category.update(category_params)
          log_to_audittrail('edit', 'CATEGORY', @category.name)

          format.html {
            redirect_to admin_categories_path, notice: "Category <strong>" + @category.name + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/categories/:id
    def destroy
      @category.destroy

      respond_to do |format|
        flash[:notice] = "Category <strong>" + @category.name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'CATEGORY', @category.name)

        flash.discard if Division.for_datatables.count(1) == 0

        format.html { redirect_to admin_categories_path }
      end
    end

    # POST /admin/datatables/retrieve_categories
    def populate_datatables
      @categories = build_datatable(Division.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @categories }
      end
    end

    private
      def category_params
        params.require(:division).permit(:name, :status)
      end

      def set_category
        @category = Division.find(params[:id])
      end
  end
end
