module Admin
  class UsersController < AdminController

    require 'sendgrid/mailer'
    include ActionView::Helpers::DateHelper
    include SendGridMailer

    before_action :check_if_has_admin_access?
    before_action :set_lookups, only: [:index, :new, :show]
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /admin/users
    def index
      @users = User.for_datatables(current_user.id)
    end

    # GET /admin/users/new
    def new
      @user = User.new
    end

    # GET /admin/users/:id
    def show
    end

    # POST /admin/users
    def create
      @user = User.new(user_params)
      @user.generate_password

      if @user.save
        send_registration_email(@user)

        log_to_audittrail('add', 'USER', @user.email)

        redirect_to admin_users_path, notice: "User <strong>" + @user.full_name + "[" + @user.email + "]</strong> has been successfully registered. Please ask the user to check the Notification Email that has been sent to him/her in order to login on the system."
      else
        set_lookups
        render :new
      end
    end

    # PATCH /admin/users/:id
    # PUT /admin/users/:id
    def update
      @user.delete_photo if params[:delete_attachment].present? && params[:delete_attachment][0] == params[:id]

      if @user.update(user_params)
        if @user.id == current_user.id
          log_to_audittrail('edit', 'PROFILE', @user.email)

          redirect_to admin_profile_index_path, notice: "Your profile has been successfully updated."
        else
          log_to_audittrail('edit', 'USER', @user.email)

          redirect_to admin_users_path, notice: "User <strong>" + @user.full_name + "[" + @user.email + "]</strong> has been successfully updated."
        end
      else
        set_lookups
        render :show
      end
    end

    # DELETE /admin/users/:id
    def destroy
      @user.destroy

      flash[:notice] = "User <strong>" + @user.full_name + "[" + @user.email + "]</strong> has been successfully deleted."
      log_to_audittrail('delete', 'USER', @user.email)

      flash.discard if User.for_datatables(current_user.id).count(1) == 0

      redirect_to admin_users_path
    end

    # POST /admin/datatables/retrieve_users
    def populate_datatables
      @users = build_datatable(User.for_datatables(current_user.id))

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @users }
      end
    end

    private
      def user_params
        params_new = params.require(:user).permit(:role_id, :email, :first_name, :middle_name, :last_name, :address1, :phone, :mobile, :photo, :password, :password_confirmation)

        return params_new[:password].blank? ? params_new.except(:password, :password_confirmation, :current_password) : params_new
      end

      def set_lookups
        @roles = Role.active_roles
      end

      def set_user
        @user = User.find(params[:id])
      end

      def check_if_has_admin_access?
        redirect_to admin_dashboard_index_path, error: "You don't have enough permission to access <strong>#{params[:controller]}</strong>." and return unless current_user.is_super_admin? || current_user.is_admin?
      end
  end
end
