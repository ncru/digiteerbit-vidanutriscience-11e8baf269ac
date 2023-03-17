module Admin
  class CompanyDetailsController < AdminController

    before_action :set_company_detail, only: [:edit, :update]

    # GET /admin/about-us
    def index
      redirect_to new_admin_company_detail_path and return unless CompanyDetail.first.present?

      @company_detail = CompanyDetail.first
    end

    # GET /admin/about-us/new
    def new
      @company_detail = CompanyDetail.new
    end

    # POST /admin/about-us
    def create
      @company_detail = CompanyDetail.new(company_detail_params)

      respond_to do |format|
        if @company_detail.save
          log_to_audittrail('add', 'COMPANY DETAILS', '')

          format.html {
            redirect_to admin_company_details_path, notice: "Company Details has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/about-us/:id/edit
    def edit
    end

    # PATCH /admin/about-us/:id
    # PUT /admin/about-us/:id
    def update
      @company_detail.delete_photo if params[:delete_attachment].present? && params[:delete_attachment][0] == params[:id]

      respond_to do |format|
        if @company_detail.update(company_detail_params)
          log_to_audittrail('edit', 'COMPANY DETAILS', '')

          format.html {
            redirect_to admin_company_details_path, notice: "Company Details has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    private
      def company_detail_params
        params.require(:company_detail).permit(:content, :photo)
      end

      def set_company_detail
        @company_detail = CompanyDetail.find(params[:id])
      end
  end
end
