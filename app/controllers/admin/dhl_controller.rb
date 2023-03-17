module Admin
  class DhlController < AdminController
    require 'dhl/shipment_validate'
    require 'dhl/book_pickup'
    require 'dhl/modify_pickup'
    require 'dhl/cancel_pickup'
    require 'dhl/tracking'
    
    before_action :set_lookups
    
    def validate_shipment
      dhl_params = params[:dhl]      
      request = ShipmentValidateRequest.new
      
      request.message_reference(@order.request_id)
      request.consignee_details(@order)
      request.shipper_details(@shipper)
      request.product_and_package(params[:dhl])
      
      request.pieces << ShipmentValidatePiece.new(:weight => @order.total_weight)
        
      response = request.post
      
      if response.error? 
        flash[:error] = response.error
      else
        @order_status = OrderStatus.find_by_dhl_service_id(params[:dhl_service_id])
        @order.update_attribute :order_status_id, @order_status.id || nil
        if @order.dhl_response_value.present?
          @order.dhl_response_value.update_attributes(label_image_base64: response.label_image_base64, awb_number: response.awb_number, product_code: dhl_params[:product_code], package_type: dhl_params[:package_type])
        else
          @order.create_dhl_response_value(label_image_base64: response.label_image_base64, awb_number: response.awb_number, product_code: dhl_params[:product_code], package_type: dhl_params[:package_type])
        end
        flash[:notice] = "DHL: Your shipment request for [Order ID: <strong>" + @order.request_id + "</strong>] has been successfully verified"
      end
      redirect_to '/admin/orders'
    end
    
    def label_image
      @pdf = Base64.decode64(@order.dhl_response_value.label_image_base64)
      send_data(@pdf, :type => 'application/pdf', :filename => @order.request_id, :disposition => "inline")
    end
    
    def book_pickup
      request = BookPickupRequest.new
      
      request.message_reference(@order.request_id)
      request.consignee_details(@order)
      request.shipper_details(@shipper)
      request.ready_date(params[:ready_date])
      request.package_location(params[:package_location])
      
      response = request.post
      
      if response.error?
        flash[:error] = response.error
      elsif response.success?
        @order_status = OrderStatus.find_by_dhl_service_id(params[:dhl_service_id])
        @order.update_attribute :order_status_id, @order_status.id
        @order.dhl_response_value.update_attributes(confirmation: response.confirmation_number, pickup_date: params[:ready_date])
        flash[:notice] = "DHL: Order ID <strong>" + @order.request_id + "</strong> is now ready for pickup."
      end
      redirect_to '/admin/orders'
    end
    
    def modify_pickup
      request = ModifyPickupRequest.new
      
      request.message_reference(@order.request_id)
      request.confirmation_number(@order.dhl_response_value.confirmation)
      request.shipper_details(@shipper)
      request.ready_date(params[:ready_date])
      request.package_location(params[:package_location])
      
      response = request.post
      
      if response.error?
        flash[:error] = response.error
      elsif response.success?
        @order_status = OrderStatus.find_by_dhl_service_id(params[:dhl_service_id])
        @order.update_attribute :order_status_id, @order_status.id
        @order.dhl_response_value.update_attribute :pickup_date, params[:ready_date]
        flash[:notice] = "DHL: Order ID <strong>" + @order.request_id + "</strong> is now ready for shipping."
      end
      redirect_to '/admin/orders'
    end
    
    def cancel_pickup
      request = CancelPickupRequest.new
      
      request.message_reference(@order.request_id)
      @dhl_response = @order.dhl_response_value 
      request.cancel_pickup_params(@dhl_response.confirmation ,@dhl_response.pickup_date, @shipper.country_code)
      
      response = request.post
      
      if response.error?
        flash[:error] = response.error
      elsif response.success?
        @order_status = OrderStatus.find_by_dhl_service_id(params[:dhl_service_id])
        @order.update_attribute :order_status_id, @order_status.id
        flash[:notice] = "DHL: Pickup for Order ID <strong>" + @order.request_id + "</strong> is now cancelled."
      end
      redirect_to '/admin/orders'
    end
    
    def tracking
      request = TrackingRequest.new
      request.message_reference(@order.request_id)
      request.awb_number(@order.dhl_response_value.awb_number)
      response = request.post
      
      if response.success?  
        @history = response.shipment_history
        if @history.present?
          @dhl_status = (@history.last["ServiceEvent"]["EventCode"] == "OK") ? "Delivered" : "In Transit"
          @tooltip_title = (@history.last["ServiceEvent"]["EventCode"] == "OK") ? @history.last["ServiceEvent"]["Description"] : ("In Transit: " + @history.last["ServiceEvent"]["Description"]) 
        else
          @dhl_status = "Shipment Information Recieved"
          @tooltip_title = @dhl_status
        end  
        @is_disabled = true
      elsif response.error? && response.error.present?
        @dhl_status = response.error == "No Shipments Found" ? "Ready For Pickup" : response.error
        @tooltip_title = @dhl_status
      else
        @dhl_status = "Tracking Failed"
        @tooltip_title = @dhl_status
      end
      
      respond_to do |format|
        format.json  { 
          render :json => { dhl_status: @dhl_status, tooltip_title: @tooltip_title, is_disabled: @is_disabled || false}
        }
      end  
    end
  
    private
      def set_lookups
        @order = Order.find_by_request_id(params[:order_request_id])
        @shipper = DhlShipperAccount.first
      end
      
  end
  
end
