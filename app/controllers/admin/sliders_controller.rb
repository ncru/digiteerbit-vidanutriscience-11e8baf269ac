module Admin
  class SlidersController < AdminController

    before_action :set_cors
    after_action :remove_flashes_on_ajax_page
    respond_to :html, :js

    # GET /admin/sliders
    def index
      @sliders = Slider.available_sliders
      puts "asdasd: #{@sliders.inspect}"
    end

    # GET /admin/sliders/:id/edit
    def edit
      @slider = Slider.find(params[:id])
    end

    # PATCH /admin/sliders/:id
    # PUT /admin/sliders/:id
    def update
      @sliders = Slider.available_sliders
      slider = Slider.find(params[:id])

      respond_to do |format|
        if slider.update_attributes(slider_params)
          flash[:notice] = "<strong>" + slider.title + "</strong> has been successfully updated."
          log_to_audittrail('edit', 'SLIDER', slider.title)

          format.js
        else
          flash[:error] = "A problem has been encountered while updating <strong>" + slider.title + "</strong>. Please try again later or contact your system administrator."

          format.js
        end
      end
    end

    # This method updates the status of sliders via AJAX.
    def update_slider_status
      # Decode the JSON String parameter passed by browser to
      # a hash object to be able to read by Ruby.
      hash = ActiveSupport::JSON.decode(params[:json_string])

      # Iterate through the sliders and update
      # their status.
      hash["sliders"].each do |s|
        slider = Slider.find(s['id'].to_i)
        slider.update_attributes(s['value'])
      end

      # Dummy empty response.
      respond_to do |format|
        format.json  { render :json => {:dummy => ""}}
      end
    end

    private
      def slider_params
        params.require(:slider).permit(:title, :excerpt, :photo_url, :external_link, :mobile_photo_url, :status)
      end
  end
end
