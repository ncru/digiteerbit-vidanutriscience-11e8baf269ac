class Admin::OrdersController < AdminController
  include ActionView::Helpers::DateHelper

  before_action :set_lookups, only: [:index]
  
  # GET /admin/orders
  def index
    @orders = Order.for_datatables
  end

  # GET /admin/orders/:id
  def show
    @order = Order.find_by(request_id: params[:id])
  end
  
  # PATCH /admin/orders/:id
  # PUT /admin/orders/:id
  def update
    @order = Order.find(params[:id])
    
    if @order.update(order_params)
      flash[:notice] = "Order <strong>" + @order.request_id + "</strong> has been successfully updated."
      log_to_audittrail('edit', 'ORDER', @order.request_id)
    end
  end
  
  # POST /admin/datatables/retrieve_orders
  def populate_datatables
    @orders = build_datatable(Order.for_datatables)

    # Return the data being expected by the client.
    respond_to do |format|
      format.json  { @orders }
    end
  end
  
  # POST /admin/json/retrieve_order_details
  def retrieve_order_details
    order = Order.find_by(request_id: params[:request_id])
    order_items = Order.order_item_details(params[:request_id])
    
    # Return the data being expected by the client.
    respond_to do |format|
      format.json  { 
        render :json => {
          data:        order,
          order_items: order_items,
          customer:    order.customer,
          shipping_address: order.shipping_address
        }
      }
    end
  end

  private
    def order_params
      params.require(:order).permit(:order_status_id)
    end
    
    def set_lookups
      @order_statuses = OrderStatus.for_select_items
      @dhl_products = DhlProduct.active_dhl_products
      @dhl_package_types = DhlPackageType.active_dhl_package_types
      @shipper = DhlShipperAccount.first
    end
end
