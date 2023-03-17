module Admin
  class ShippingDetailsController < AdminController

    before_action :set_shipping_detail, only: [:edit, :update]

    # GET /admin/shipping-details
    def index
      redirect_to new_admin_shipping_detail_path and return unless ShippingDetail.first.present?

      @shipping_detail = ShippingDetail.first
    end

    # GET /admin/shipping-details/new
    def new
      @shipping_detail = ShippingDetail.new
    end

    # POST /admin/shipping-details
    def create
      @shipping_detail = ShippingDetail.new(shipping_detail_params)

      respond_to do |format|
        if @shipping_detail.save
          log_to_audittrail('add', 'SHIPPING DETAILS', '')

          format.html {
            redirect_to admin_shipping_details_path, notice: "Shipping Details has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/shipping-details/:id/edit
    def edit
    end

    # PATCH /admin/shipping-details/:id
    # PUT /admin/shipping-details/:id
    def update
      respond_to do |format|
        if @shipping_detail.update(shipping_detail_params)
          log_to_audittrail('edit', 'SHIPPING DETAILS', '')

          format.html {
            redirect_to admin_shipping_details_path, notice: "Shipping Details has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    private
      def shipping_detail_params
        params.require(:shipping_detail).permit(:content)
      end

      def set_shipping_detail
        @shipping_detail = ShippingDetail.find(params[:id])
      end
  end
end
