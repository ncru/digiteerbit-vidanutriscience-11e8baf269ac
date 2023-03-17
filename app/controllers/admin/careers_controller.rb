module Admin
  class CareersController < AdminController

    before_action :set_career, only: [:edit, :update, :destroy]

    # GET /admin/careers
    def index
      @careers = Career.for_datatables
    end

    # GET /admin/careers/new
    def new
      @career = Career.new
    end

    # POST /admin/careers
    def create
      @career = Career.new(career_params)

      respond_to do |format|
        if @career.save
          log_to_audittrail('add', 'CAREER', @career.position)

          format.html {
            redirect_to admin_careers_path, notice: "Career <strong>" + @career.position + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/careers/:id/edit
    def edit
    end

    # PATCH /admin/careers/:id
    # PUT /admin/careers/:id
    def update
      respond_to do |format|
        if @career.update(career_params)
          log_to_audittrail('edit', 'CAREER', @career.position)

          format.html {
            redirect_to admin_careers_path, notice: "Career <strong>" + @career.position + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/careers/:id
    def destroy
      @career.destroy

      respond_to do |format|
        flash[:notice] = "Career <strong>" + @career.position + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'CAREER', @career.position)

        flash.discard if Career.for_datatables.count(1) == 0

        format.html { redirect_to admin_careers_path }
      end
    end

    # POST /admin/datatables/retrieve_careers
    def populate_datatables
      @careers = build_datatable(Career.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @careers }
      end
    end

    private
      def career_params
        params.require(:career).permit(:position, :description, :status)
      end

      def set_career
        @career = Career.find(params[:id])
      end
  end
end
