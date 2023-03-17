module Admin
  class InventoriesController < AdminController
    before_action :set_lookups, only: [:new]
    
    def index
      @inventories = Inventory.for_datatables
    end
    
    # GET /admin/inventorys/new
    def new
      @inventory = Inventory.new
    end

    # POST /admin/inventorys
    def create
      @inventory = Inventory.new(inventory_params)
      @inventory.user_id = current_user.id
      respond_to do |format|
        if @inventory.save
          format.html {
            redirect_to admin_inventories_path, notice: "Inventory has been successfully added."
          }
        else
          set_lookups
          format.html { render :new }
        end
      end
    end
    
    def show
      @sku_id = params[:id]
      @sku = Sku.find(@sku_id)
    end

    def populate_datatables
      @inventories = build_datatable(Inventory.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @inventories }
      end
    end
    
    def populate_show_datatables
      sku_id = params[:sku_id].to_i
      @inventories = build_datatable(Inventory.for_show_datatables(sku_id))

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @inventories }
      end
    end

    private
      def inventory_params
        params.require(:inventory).permit( :user_id, inventory_items_attributes: [:inventory_id, :sku_id, :action_id, :quantity, :status_id, :remarks])
      end  
      
      def set_lookups
        @skus = Sku.available_skus
        @actions = [["Add", 1], ["Deduct", 2]]
        @status = [["Sold",1],["Returned",2],["Damaged" ,3], ["Lost", 4]]
      end
  end
end
