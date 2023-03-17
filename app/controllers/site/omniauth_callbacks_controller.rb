module Site
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def facebook
      @customer = Customer.from_omniauth(request.env["omniauth.auth"])

      if @customer.persisted?
        sign_in_and_redirect @customer
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        email = request.env["omniauth.auth"].info.email
        flash[:alert] = "#{email} is already registered to our system. Please signin instead."
        redirect_to new_customer_session_path
      end
    end

    def failure
      redirect_to root_path
    end

    def after_omniauth_failure_path_for
      root_path
    end

    def after_sign_in_path_for(resource)
      root_path
    end
  end
end
