module Admin
  class SessionsController < Devise::SessionsController
    layout 'devise'

    # GET /admin/login
    def new
      super
    end

    # POST /admin/login
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      if !session[:return_to].blank?
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
    end

    # Overwriting the sign_in redirect path method
    def after_sign_in_path_for(resource)
      admin_dashboard_index_path
    end

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource)
      new_user_session_path
    end
  end
end
