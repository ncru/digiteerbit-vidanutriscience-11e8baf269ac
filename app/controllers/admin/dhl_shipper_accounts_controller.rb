module Admin
  class DhlShipperAccountsController < AdminController

    before_action :set_dhl_shipper_account, only: [:edit, :update]
    before_action :set_lookups
    # GET /admin/dhl-shipper-accounts
    def index
      @dhl_shipper_account = DhlShipperAccount.first
      unless @dhl_shipper_account.present?
        @dhl_shipper_account = DhlShipper.new
      end
    end

    # POST /admin/dhl-shipper-accounts
    def create
      @dhl_shipper_account = DhlShipperAccount.new(dhl_shipper_account_params)

      respond_to do |format|
        if @dhl_shipper_account.save
          log_to_audittrail('add', 'DHL SHIPPER ACCOUNT', @dhl_shipper_account.account_number)

          format.html {
            redirect_to admin_dhl_shipper_accounts_path, notice: "DHL Shipper Account <strong>" + @dhl_shipper_account.account_number + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # PATCH /admin/dhl-shipper-accounts/:id
    # PUT /admin/dhl-shipper-accounts/:id
    def update
      respond_to do |format|
        if @dhl_shipper_account.update(dhl_shipper_account_params)
          log_to_audittrail('edit', 'DHL SHIPPER ACCOUNT', @dhl_shipper_account.account_number)

          format.html {
            redirect_to admin_dhl_shipper_accounts_path, notice: "DHL Shipper Account <strong>" + @dhl_shipper_account.account_number + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    private
      def dhl_shipper_account_params
        params.require(:dhl_shipper_account).permit(:account_number, :shipper_id, :company, :address1, :address2, :city, :postal_code, :country_code, :contact_person, :contact_no, :default_product_code, :default_package_type, :ready_time, :close_time,:status)
      end
      
      def set_lookups
        @countries = Country.active_countries
        @dhl_products = DhlProduct.active_dhl_products
        @dhl_package_types = DhlPackageType.active_dhl_package_types
      end
      
      def set_dhl_shipper_account
        @dhl_shipper_account = DhlShipperAccount.find(params[:id])
      end
  end
end
