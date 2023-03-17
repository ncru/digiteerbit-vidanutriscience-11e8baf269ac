module Site
  class SessionsController < Devise::SessionsController
    layout 'site'

    include CustomerCart
    include GlobalObjects
    
    def new
      session[:site_return_to] = params[:site_return_to] if params[:site_return_to].present?
      super
    end

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)

      respond_with resource, location: after_sign_in_path_for(resource)
    end

    def edit
      super
    end

    def update
      super
    end

    def after_sign_in_path_for(customer)
      session[:site_return_to].present? ? session[:site_return_to] : order_history_path
    end
  end
end
