module Admin
  class ShippingRatesController < AdminController

    before_action :set_shipping_rate, only: [:edit, :update, :destroy]
    before_action :set_lookups, only: [:new]
    before_action :set_lookups2, only: [:edit]
    # GET /admin/shipping_rates
    def index
      @shipping_rates = ShippingRate.for_datatables
    end

    # GET /admin/shipping_rates/new
    def new
      @shipping_rate = ShippingRate.new
    end

    # POST /admin/shipping_rates
    def create
      @shipping_rate = ShippingRate.new(shipping_rate_params)

      respond_to do |format|
        if @shipping_rate.save
          log_to_audittrail('add', 'SHIPPING RATE', @shipping_rate.get_countries)

          format.html {
            redirect_to admin_shipping_rates_path, notice: "Shipping Rate [<strong>"+@shipping_rate.get_countries+"</strong>] has been successfully added."
          }
        else
          set_lookups
          format.html { render :new }
        end
      end
    end

    # GET /admin/shipping_rates/:id/edit
    def edit
    end

    # PATCH /admin/shipping_rates/:id
    # PUT /admin/shipping_rates/:id
    def update
      respond_to do |format|
        if @shipping_rate.update(shipping_rate_params)
          log_to_audittrail('edit', 'SHIPPING RATE', @shipping_rate.get_countries)

          format.html {
            redirect_to admin_shipping_rates_path, notice: "Shipping Rate <strong>[" + @shipping_rate.get_countries + "]</strong> has been successfully updated."
          }
        else
          set_lookups2
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/shipping_rates/:id
    def destroy
      @shipping_rate.destroy

      respond_to do |format|
        flash[:notice] = "Shipping Rate <strong>[" + @shipping_rate.get_countries + "]</strong> has been successfully removed."
        log_to_audittrail('delete', 'SHIPPING RATE', @shipping_rate.country_names.join(',  '))

        flash.discard if ShippingRate.for_datatables.count(1) == 0

        format.html { redirect_to admin_shipping_rates_path }
      end
    end

    # POST /admin/datatables/retrieve_shipping_rates
    def populate_datatables
      @shipping_rates = build_datatable(ShippingRate.for_datatables)
      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @shipping_rates }
      end
    end

    private
      def shipping_rate_params
        params.require(:shipping_rate).permit({country_codes: []}, :kg0p5, :kg1p0, :kg1p5, :kg2p0, :kg2p5, :kg3p0, :kg3p5, :kg4p0, :kg4p5, :kg5p0, :kg5p5, :kg6p0, :kg6p5, :kg7p0, :kg7p5, :kg8p0, :kg8p5, :kg9p0, :kg9p5, :kg10p0, :kg_add_on, :status)
      end
      
      def set_lookups
        @countries = Country.shipping_rate_new
      end
      
      def set_lookups2
        @countries = Country.shipping_rate_edit(@shipping_rate.id)
      end

      def set_shipping_rate
        @shipping_rate = ShippingRate.find(params[:id])
      end
  end
end
