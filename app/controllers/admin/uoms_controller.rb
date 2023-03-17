module Admin
  class UomsController < AdminController

    before_action :set_lookups, only: [:new, :edit]
    before_action :set_uom, only: [:edit, :update, :destroy]

    # GET /admin/maintenance/uoms
    def index
      @uoms = Uom.for_datatables
    end

    # GET /admin/maintenance/uoms/new
    def new
      @uom = Uom.new
    end

    # POST /admin/maintenance/uoms
    def create
      @uom = Uom.new(uom_params)

      respond_to do |format|
        if @uom.save
          log_to_audittrail('add', 'UOM', @uom.name)

          format.html {
            redirect_to admin_uoms_path, notice: "UOM <strong>" + @uom.name + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/maintenance/uoms/:id/edit
    def edit
    end

    # PATCH /admin/maintenance/uoms/:id
    # PUT /admin/maintenance/uoms/:id
    def update
      respond_to do |format|
        if @uom.update(uom_params)
          log_to_audittrail('edit', 'UOM', @uom.name)

          format.html {
            redirect_to admin_uoms_path, notice: "UOM <strong>" + @uom.name + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/maintenance/uoms/:id
    def destroy
      @uom.destroy

      respond_to do |format|
        flash[:notice] = "UOM <strong>" + @uom.name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'UOM', @uom.name)

        flash.discard if Uom.for_datatables.count(1) == 0

        format.html { redirect_to admin_uoms_path }
      end
    end

    # POST /admin/datatables/retrieve_uoms
    def populate_datatables
      @uoms = build_datatable(Uom.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @uoms }
      end
    end

    private
      def uom_params
        params.require(:uom).permit(:name, :unit, :status, :uom_label_id)
      end

      def set_uom
        @uom = Uom.find(params[:id])
      end

      def set_lookups
        @uom_labels = UomLabel.available_uom_labels
      end
  end
end
