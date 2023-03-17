class Admin::PriceUpdatesController < AdminController
  
  before_action :set_lookups, only: [:new]
  # GET /admin/price_updates
  def index
    @price_updates = PriceUpdate.for_datatables
  end

  # GET /admin/price_updates/new
  def new
    @price_update = PriceUpdate.new
  end

  # POST /admin/price_updates
  def create
    @price_update = PriceUpdate.new(price_update_params)
    @price_update.user_id = current_user.id
    respond_to do |format|
      if @price_update.save
        format.html {
          redirect_to admin_price_updates_path, notice: "Price Update has been successfully added."
        }
      else
        set_lookups
        format.html { render :new }
      end
    end
  end
  
  def get_sku_price
    @prices = PriceUpdate.get_regular_price(params[:sku_id])
    if @prices.present?
      @regular_price = @prices.first.price
    else
      @regular_price = "0"
    end
    @data_id = "#" +params[:data_id]
  end

  # POST /admin/datatables/retrieve_price_updates
  def populate_datatables
    @price_updates = build_datatable(PriceUpdate.for_datatables)

    # Return the data being expected by the client.
    respond_to do |format|
      format.json  { @price_updates }
    end
  end
  
  # POST /admin/datatables/retrieve_price_history
  def populate_history_datatables
    @price_history = build_datatable(PriceUpdate.price_history)

    # Return the data being expected by the client.
    respond_to do |format|
      format.json  { @price_history }
    end
  end

  private
    def price_update_params
      params.require(:price_update).permit(:promo_name, :start_date, :end_date, :has_no_end_date, :price_type, :sale_type, :user_id, price_update_items_attributes: [:price_update_id, :sku_id, :promo_price, :price])
    end  
    
    def set_lookups
      @product = Sku.available_skus
      @price_types = [["Regular Price", 0], ["Promo Price", 1]]
      @promo_types = [["By Actual Price",1],["By Percentage",2]]
    end
end
