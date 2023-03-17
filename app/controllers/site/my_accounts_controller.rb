module Site
  class MyAccountsController < SiteController
    include ActionView::Helpers::DateHelper
    before_action :set_cache_headers, only: [:index, :show]
    before_action :redirect_if_not_signed_in, only: [:index, :show, :order_history]
    before_action :set_customer, only: [:show, :update]
    after_action :remove_flashes_on_ajax_page

    def index
    end

    def show
      set_lookups
    end

    def update
      if @customer.update(customer_params)
        bypass_sign_in(@customer) if customer_params[:password].present?
        
        redirect_to my_account_path, notice: "Your account details has been successfully updated."
      else
        set_lookups
        render :show
      end
    end
    
    def order_history
    end

    private
      def customer_params
        customer_params = params.require(:customer).permit(:id, :password, :password_confirmation, :first_name, :middle_name, :last_name, :photo, :mobile, :address1, :address2, :city, :state, :country_code, :zip_code, :shipping_address1, :shipping_address2, :shipping_city, :shipping_state, :shipping_country_code, :shipping_zip_code)
        
        unless customer_params[:password].present?
          # Remove the password and password confirmation in the hash if it's not supplied.
          return customer_params.except(:password, :password_confirmation, :current_password)
        end
        
        customer_params
      end
      
      def set_customer
        @customer = current_customer
      end

      def set_lookups
        @countries = Country.active_countries
      end
  end
end
