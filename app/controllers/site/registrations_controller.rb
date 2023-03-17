module Site
  class RegistrationsController < Devise::RegistrationsController
    layout 'site'

    require 'sendgrid/mailer'
    include CustomerCart
    include GlobalObjects
    include SendGridMailer

    skip_before_action :verify_authenticity_token, :only => :create

    def new
      session[:site_return_to] = params[:site_return_to] if params[:site_return_to].present?
      super
    end

    def create
      super
    end

    def edit
      super
    end

    def update
      super
    end

    def after_sign_up_path_for(resource)
      send_customer_registration_email(resource)

      session[:site_return_to].present? ? session[:site_return_to] : root_path
    end

    private
      def sign_up_params
        params.require(:customer).permit(:photo,:email,:password,:first_name,:last_name,:middle_name,:role_id,:last_sign_in_at,:sign_in_count,:reset_password_token,:password_confirmation,:address1,:city,:state,:country_code,:zip_code,:phone,:mobile)
      end
  end
end
