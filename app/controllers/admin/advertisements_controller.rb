module Admin
  class AdvertisementsController < AdminController

    before_action :set_cors, only: [:edit, :new]
    before_action :set_advertisement, only: [:edit, :update, :destroy]

    # GET /admin/advertisements
    def index
      @advertisements = Advertisement.for_datatables
    end

    # GET /admin/advertisements/new
    def new
      @advertisement = Advertisement.new
    end

    # POST /admin/advertisements
    def create
      @advertisement = Advertisement.new(advertisement_params)

      if @advertisement.save
        log_to_audittrail('add', 'ADVERTISEMENT', @advertisement.name)

        redirect_to admin_advertisements_path, notice: "Advertisement <strong>" + @advertisement.name + "</strong> has been successfully added."
      else
        render :new
      end
    end

    # GET /admin/advertisements/:id/edit
    def edit
    end

    # PATCH /admin/advertisements/:id
    # PUT /admin/advertisements/:id
    def update
      if @advertisement.update(advertisement_params)
        log_to_audittrail('edit', 'ADVERTISEMENT', @advertisement.name)

        redirect_to admin_advertisements_path, notice: "Advertisement <strong>" + @advertisement.name + "</strong> has been successfully updated."
      else
        render :edit
      end
    end

    # DELETE /admin/advertisements/:id
    def destroy
      @advertisement.destroy

      log_to_audittrail('delete', 'ADVERTISEMENT', @advertisement.name)

      flash.discard if Advertisement.for_datatables.count(1) == 0

      redirect_to admin_advertisements_path, notice: "Advertisement <strong>" + @advertisement.name + "</strong> has been successfully removed."
    end

    # POST /admin/datatables/retrieve_advertisements
    def populate_datatables
      @advertisements = build_datatable(Advertisement.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @advertisements }
      end
    end

    private
      def advertisement_params
        params.require(:advertisement).permit(:name, :description, :status, :photo_url)
      end

      def set_advertisement
        @advertisement = Advertisement.find(params[:id])
      end
  end
end
