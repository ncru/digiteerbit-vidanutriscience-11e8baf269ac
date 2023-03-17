module Admin
  class RegistrationsController < Devise::RegistrationsController

    skip_before_action :verify_authenticity_token, :only => :create

    # GET /admin/register
    def new
      @user = User.new
    end

    # POST /admin/register
    def create
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          redirect_to admin_dashboard_index_path, notice: 'User successfully added.'
        end
      end
    end

    # GET /admin/register/edit
    def edit
      super
    end

    # PUT /admin/register
    def update
      super
    end
  end
end
