module Site
  class CheckoutController < SiteController
    
    # require 'global_payments/vpc' # for MiGS Virtual Payment Client (Global Payments)
    require 'dhl/get_quote'
    # include VPCConnection
    include ApplicationHelper
    
    before_action :redirect_if_not_signed_in
    before_action :set_cache_headers, only: [:index]
    skip_before_action :verify_authenticity_token, only: [:paynamics_checkout]

    def index
      respond_to do |format|
        @order = @cart.order.present? ? @cart.order : @cart.build_order
        @countries = Country.active_countries_from_shipping
        @couriers = [{:name=>'Xend', :id=>1}, {:name=>'DHL', :id=>2}]
        province_id           = @addresses && @addresses.size > 0 ? @addresses.first.state_id : nil
        @shipping_states      = Province.all
        @shipping_cities      = (@order.present?) && @order.shipping_state_id.present? ? City.where(province_id: @order.shipping_state_id): []
        if current_customer.shipping_country_code.present?
          check_restrited_products(current_customer.shipping_country_code)
        end
        format.js
        format.html
      end
    end
    
    def payment
      respond_to do |format|
        @order = @cart.order
        format.js
        format.html
      end
    end
    
    def update_shipping
      shipping_rate_id = params[:shipping_rate_id]
      shipping_country_code = params[:shipping_country_code]
      postal_code = params[:postal_code]
      courier_id = params[:courier_id]
      
      if courier_id.to_i == 1 || shipping_country_code == "PH" # Xend 
        @shipping_rate = ShippingRate.find(shipping_rate_id)
        @shipping_fee = @shipping_rate.get_shipping_price(@cart.total_weight)
      elsif courier_id.to_i == 2 # DHL 
        dhl_get_quote(shipping_country_code, postal_code)
      end
      check_restrited_products(shipping_country_code)
    end
    
    def dhl_get_quote(country_code, postal_code)
      request = GetQuoteRequest.new
      
      request.metric_measurements!

      # r.add_special_service("DD")

      request.to(country_code, postal_code)
      request.from('PH', 1106) # Vida NutriScience's country code and zip code 
      
      request.pieces << GetQuotePiece.new(:weight => @cart.total_weight)

      response = request.post
      if response.error? 
        @dhl_error = response.error
        puts flash[:dhl_error]
      elsif response.total_amount.to_f == 0
        @dhl_error = "Something went wrong!"
      else
        @shipping_fee = response.total_amount || 0
      end
    end
    
    # MiGS Virtual Payment Clent API (Global Payments)
    def vpc_checkout
      total_amount = @cart.subtotal + @cart.order.shipping_fee
      VPC_GATEWAY.setup_purchase(
        vpc_Amount:         (total_amount * 100).to_i,
        vpc_Command:        'pay',
        vpc_Locale:         'en',
        vpc_MerchTxnRef:    @cart.order.request_id,
        vpc_Merchant:       (ENV["PAYMENT_API_MODE"] == "live") ? ENV["VPC_MERCHANT_ID"] : 'gpmnl073002798001',
        vpc_OrderInfo:      @cart.order.request_id,
        vpc_ReturnURL:      root_url.to_s + 'thank-you',
        vpc_Version:        1
      )
      puts VPC_GATEWAY.get_vpc_url
      redirect_to VPC_GATEWAY.get_vpc_url
    end
    
    # Paynamics Checkout.
    def paynamics_checkout
      client   = Paynamics.client
      @payload = client.build_purchase_payload(paynamics_purchase_options)
      
      unless @payload.present?
        flash[:alert] = "A problem has been encountered while placing your order. Please try again."
        redirect_to checkout_path
      end
    end
    
    private
      def check_restrited_products(country_code)
        @restricted_sku_ids = []
        @cart.cart_items.each do |ci|
          @restricted_sku_ids << ci.sku.id if ci.sku.product.restricted_country_codes.include? country_code
        end
      end
      
      # Generate the options expected by paynamics api.
      def paynamics_purchase_options
        total_amount = @cart.subtotal + @cart.order.shipping_fee
        
        purchase_options = {
          request_id:               @cart.order.request_id,
          ip_address:               '174.129.25.170',
          notification_url:         ENV["PAYNAMICS_VIDA_NOTIFICATION_URL"],
          response_url:             ENV["PAYNAMICS_VIDA_RESPONSE_URL"],
          cancel_url:               ENV["PAYNAMICS_VIDA_CANCEL_URL"],
          cart_id:                  @cart.order.cart_id,
          customer_id:              @cart.order.customer_id,
          fname:                    @cart.order.first_name,
          mname:                    @cart.order.middle_name,
          lname:                    @cart.order.last_name,
          email:                    @cart.order.email,
          phone:                    @cart.order.phone,
          mobile:                   @cart.order.mobile,
          address1:                 @cart.order.shipping_address1,
          address2:                 @cart.order.shipping_address2,
          city:                     @cart.order.shipping_city,
          state:                    @cart.order.shipping_state,
          zip:                      @cart.order.shipping_zip_code,
          country:                  @cart.order.shipping_country_code,
          is_same_shipping_address: 1,
          shipping_address1:        @cart.order.shipping_address1,
          shipping_address2:        @cart.order.shipping_address2,
          shipping_city:            @cart.order.shipping_city,
          shipping_state:           @cart.order.shipping_state,
          shipping_zip:             @cart.order.shipping_zip_code,
          shipping_country:         @cart.order.shipping_country_code,
          secure3d:                 "try3d",
          client_ip:                request.remote_ip,
          pmethod:                  "",
          currency:                 "PHP",
          amount:                   format_number_with_precision_no_delimeter(total_amount, 2),
          mlogo_url: "https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/production/assets/vida-nutriscience-logo-new-2a36bc36f154c8e249223b7c1226f60c973e200fd483d509ac8bfd399b251e9f.png"
        }
        
        # Add the items to options.
        purchase_options[:orders] = purchase_items
        purchase_options
      end
      
      # Generate the items included in the purchase.
      def purchase_items
        orders = []
        
        # Populate the orders.
        # Add the cart items.
        @cart.order.order_items.each do |item|
          orders.push({
            itemname: "#{item.sku.product.name} (#{item.sku.code}: #{item.sku.name})",
            quantity: item.quantity,
            amount:   format_number_with_precision_no_delimeter(item.sku.get_price, 2),
            sku_id:   item.sku.id
          })
        end
        
        # Add the Shipping amount as item.
        orders.push({
          itemname: "Shipping Fee",
          quantity: 1,
          amount: format_number_with_precision_no_delimeter(@cart.order.shipping_fee, 2)
        })
        
        orders
      end
  end
end
