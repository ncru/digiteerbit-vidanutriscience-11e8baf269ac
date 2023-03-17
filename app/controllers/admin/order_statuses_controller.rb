module Admin
  class OrderStatusesController < AdminController

    before_action :set_cors, only: [:edit, :new]
    before_action :set_order_status, only: [:edit, :update, :destroy]

    # GET /admin/order-statuses
    def index
      @order_statuses = OrderStatus.for_datatables
    end

    # GET /admin/order-statuses/new
    def new
      @order_status = OrderStatus.new
    end

    # POST /admin/order-statuses
    def create
      @order_status = OrderStatus.new(order_status_params)

      if @order_status.save
        log_to_audittrail('add', 'ORDER STATUS', @order_status.name)

        redirect_to admin_order_statuses_path, notice: "Order Status <strong>" + @order_status.name + "</strong> has been successfully added."
      else
        render :new
      end
    end

    # GET /admin/order-statuses/:id/edit
    def edit
    end

    # PATCH /admin/order-statuses/:id
    # PUT /admin/order-statuses/:id
    def update
      if @order_status.update(order_status_params)
        log_to_audittrail('edit', 'ORDER STATUS', @order_status.name)

        redirect_to admin_order_statuses_path, notice: "Order Status <strong>" + @order_status.name + "</strong> has been successfully updated."
      else
        render :edit
      end
    end

    # DELETE /admin/order-statuses/:id
    def destroy
      @order_status.destroy

      log_to_audittrail('delete', 'ORDER STATUS', @order_status.name)

      flash.discard if OrderStatus.for_datatables.count(1) == 0

      redirect_to admin_order_statuses_path, notice: "Order Status <strong>" + @order_status.name + "</strong> has been successfully removed."
    end

    # POST /admin/datatables/retrieve_order_statuses
    def populate_datatables
      @order_statuses = build_datatable(OrderStatus.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @order_statuses }
      end
    end

    private
      def order_status_params
        params.require(:order_status).permit(:name, :status, :color_code, :level, :courier_id, :dhl_service_id)
      end

      def set_order_status
        @order_status = OrderStatus.find(params[:id])
      end
  end
end
