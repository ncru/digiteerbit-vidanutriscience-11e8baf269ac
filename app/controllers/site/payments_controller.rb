class Site::PaymentsController < SiteController
  
  require 'sendgrid/mailer'
  include CustomerCart
  include GlobalObjects
  include SendGridMailer
  
  def thank_you
    if session[:is_paynamics]
      session[:is_paynamics] = false
      @order = Order.find_by_request_id(session[:order_request_id])
      session[:order_request_id] = nil
    else
      @order = @cart.order
      case @order.payment_method_id
      when 0 # Cash On Delivery
        place_orders
      when 1 # Paypal
        return unless valid_paypal_token
        paypal_payment
      when 2 # VPC(Global Payments)
        global_payments
      end
    end
    @order_items = OrderItem.for_adwords(@order.request_id)
  end
  
  def paypal_payment
    if @cart.payment_with_paypal(request.remote_ip, params[:token], params[:PayerID])
      place_orders
    else
      flash[:error] = @cart.errors.full_messages.to_sentence
      redirect_to '/checkout'
    end
  end
  
  def global_payments
    if params[:vpc_TxnResponseCode].to_i == 0
      place_orders
    else
      flash[:error] = params[:vpc_Message]
      redirect_to '/checkout'
    end
  end
  
  def paynamics_verification
    if params[:requestid].present? && params[:responseid].present?
      session[:is_paynamics] = true
      redirect_to '/thank-you'
    end
  end
  
  def place_orders
    if @order.update(paypal_token: params[:token], 
      paypal_payer_id: params[:PayerID],
      order_status_id: SystemSetting.find_by(name: 'FIRST_ORDER_STATUS_ID').value)
      
      @inventory = Inventory.create(order_request_id: @order.request_id)
      @inventory.update_product_stocks(@order)
      
      send_order_confirmation_email(@order, @cart.subtotal)
      send_order_confirmation_email_for_admin(@order, @cart.subtotal)
      @cart.destroy    
    end
  end
  
  private
    def valid_paypal_token
      params[:token].present? && params[:token] == session[:paypal_token]
    end

end
