module Site
  class PasswordsController < Devise::PasswordsController
    layout 'site'
    
    include CustomerCart
    include GlobalObjects
    
    def new
      super
    end

    def create
      if params[:customer]["email"].blank?
        flash[:alert] = "Email is required."
        redirect_to new_customer_password_path
      else
        @customer = Customer.find_by(email: params[:customer]["email"])
        if @customer.blank?
          flash[:alert] = "The email you entered does not exist."
          redirect_to new_customer_password_path
        else
          super
        end
      end
    end

    def edit
      super
    end

    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
       yield resource if block_given?

       if resource.errors.empty?
         resource.unlock_access! if unlockable?(resource)
         if Devise.sign_in_after_reset_password
           flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
           set_flash_message(:notice, flash_message) if is_flashing_format?
         else
           set_flash_message(:notice, :updated_not_active) if is_flashing_format?
         end
         respond_with resource, location: after_resetting_password_path_for(resource)
       else
         respond_with resource
       end
    end
    
    def after_resetting_password_path_for(resource)
      flash[:alert] = "You have successfully reset your password."
      new_customer_session_path
    end
  end
end
