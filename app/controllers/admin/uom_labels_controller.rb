module Admin
  class UomLabelsController < AdminController

    before_action :set_uom_label, only: [:edit, :update, :destroy]

    # GET /admin/maintenance/uom-labels
    def index
      @uom_labels = UomLabel.for_datatables
    end

    # GET /admin/maintenance/uom-labels/new
    def new
      @uom_label = UomLabel.new
    end

    # POST /admin/maintenance/uom-labels
    def create
      @uom_label = UomLabel.new(uom_label_params)

      respond_to do |format|
        if @uom_label.save
          log_to_audittrail('add', 'UOM LABEL', @uom_label.name)

          format.html {
            redirect_to admin_uom_labels_path, notice: "UOM Label <strong>" + @uom_label.name + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/maintenance/uom-labels/:id/edit
    def edit
    end

    # PATCH /admin/maintenance/uom-labels/:id
    # PUT /admin/maintenance/uom-labels/:id
    def update
      respond_to do |format|
        if @uom_label.update(uom_label_params)
          log_to_audittrail('edit', 'UOM LABEL', @uom_label.name)

          format.html {
            redirect_to admin_uom_labels_path, notice: "UOM Label <strong>" + @uom_label.name + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/maintenance/uom-labels/:id
    def destroy
      @uom_label.destroy

      respond_to do |format|
        flash[:notice] = "UOM Label <strong>" + @uom_label.name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'UOM LABEL', @uom_label.name)

        flash.discard if UomLabel.for_datatables.count(1) == 0

        format.html { redirect_to admin_uom_labels_path }
      end
    end

    # POST /admin/datatables/retrieve_uom_labels
    def populate_datatables
      @uom_labels = build_datatable(UomLabel.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @uom_labels }
      end
    end

    private
      def uom_label_params
        params.require(:uom_label).permit(:name, :status)
      end

      def set_uom_label
        @uom_label = UomLabel.find(params[:id])
      end
  end
end
