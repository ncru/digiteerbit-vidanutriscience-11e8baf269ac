class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :error
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "devise"
    end
  end

  protected
    # Prevent flash to appear when you reload page.
    def remove_flashes_on_ajax_page
      return unless request.xhr?
      response.headers['X-Message'] = flash[:error] unless flash[:error].blank?
      response.headers['X-Message'] = flash[:notice] unless flash[:notice].blank?

      flash.discard
    end
end
