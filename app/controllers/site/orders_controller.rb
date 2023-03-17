module Site
  class OrdersController < SiteController
    def create
      Order.transaction do
        @order = current_customer.orders.new(order_params) 
        @order.amount = @cart.subtotal
        @order.cart_id = @cart.id
        set_shipping_fee
        @order.request_id = SecureRandom.hex(16)
        set_shipping_state_and_city_id
        if @order.save
          redirect_to checkout_payment_path
        else
          redirect_to "/checkout", error: @order.errors.full_messages.to_s
        end
      end
    end
    
    def update
      Order.transaction do
        @order = Order.find(params[:id])
        set_shipping_fee if params[:wizard_page] == 'customer_info'
        set_shipping_state_and_city_id
        if @order.update(order_params)
          case params[:wizard_page]
            when "customer_info"
              redirect_to checkout_payment_path
            when "payment"
              case @order.payment_method_id
                when 0 # 
                  redirect_to '/thank-you'
                when 1 # Paypal
                  express_checkout
                when 2 # VPC(Global Payments)
                  redirect_to "/vpc-checkout"
                when 3 # Paynamics
                  session[:order_request_id] = @order.request_id
                  redirect_to paynamics_checkout_path, turbolinks: false
              end 
          end
        else
          @error = @order.errors.full_messages.first.to_s
          redirect_to checkout_path, error: @error
        end
      end
    end
    
    private
      def order_params
        params.require(:order).permit(:customer_id, :request_id, :email, :first_name, :last_name, :country_code, :mobile, :shipping_address1, :shipping_address2, :shipping_city, :shipping_state, :shipping_zip_code, :shipping_country_code, :courier_id, :payment_method_id, :shipping_state_id, :shipping_city_id)
      end
      
      def set_shipping_fee
        if @order.courier_id == 1 || @order.shipping_country_code == 'PH'
          @shipping_rate = ShippingRate.where("? = ANY(country_codes)", @order.shipping_country_code).first
          @order.shipping_fee = @shipping_rate.present? ? @shipping_rate.get_shipping_price(@cart.total_weight) : 0
        elsif @order.courier_id == 2
          dhl_response = @order.get_dhl_shipping_fee_response
          if dhl_response.error? || dhl_response.total_amount.to_f == 0
            redirect_to "/checkout", error: dhl_response.error || "Something went wrong with DHL." and return   
          else
            @order.shipping_fee = dhl_response.total_amount.to_f
          end
        end
      end

      def set_shipping_state_and_city_id
        unless @order.shipping_country_code == 'PH'
          @order.shipping_state_id = nil
          @order.shipping_city_id = nil
        end
      end
      
      def express_checkout
        @total_amount = (@cart.subtotal.to_f + @cart.order.shipping_fee.to_f) * 100
        response = EXPRESS_GATEWAY.setup_purchase(
          @total_amount.to_i,
          ip:                request.remote_ip,
          return_url:        root_url.to_s + 'thank-you',
          cancel_return_url: root_url.to_s + 'checkout',
          subtotal:          @cart.subtotal.to_f * 100,
          shipping:          @cart.order.shipping_fee.to_f * 100,
          tax:               0,
          handling:          0,
          currency:          'PHP',
          items:             @cart.express_checkout_items
        )

        # Store the response token for later verification.
        session[:paypal_token] = response.token
        
        redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
      end
  end
end
