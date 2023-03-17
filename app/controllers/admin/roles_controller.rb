module Admin
  class RolesController < AdminController

    before_action :check_if_has_super_admin_access?
    before_action :set_role, only: [:edit, :update, :destroy]

    # GET /admin/roles
    def index
      @roles = Role.for_datatables
    end

    # GET /admin/roles/new
    def new
      @role = Role.new
    end

    # POST /admin/roles
    def create
      @role = Role.new(role_params)

      respond_to do |format|
        if @role.save
          log_to_audittrail('add', 'ROLE', @role.name)

          format.html {
            redirect_to admin_roles_path, notice: "Role <strong>" + @role.name + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/roles/:id/edit
    def edit
    end

    # PATCH /admin/roles/:id
    # PUT /admin/roles/:id
    def update
      respond_to do |format|
        if @role.update(role_params)
          log_to_audittrail('edit', 'ROLE', @role.name)

          format.html {
            redirect_to admin_roles_path, notice: "ROLE <strong>" + @role.name + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/roles/:id
    def destroy
      @role.destroy

      respond_to do |format|
        flash[:notice] = "ROLE <strong>" + @role.name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'ROLE', @role.name)

        flash.discard if Role.for_datatables.count(1) == 0

        format.html { redirect_to admin_roles_path }
      end
    end

    # POST /admin/datatables/retrieve_roles
    def populate_datatables
      @roles = build_datatable(Role.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @roles }
      end
    end

    private
      def role_params
        params.require(:role).permit(:name, :status)
      end

      def check_if_has_super_admin_access?
        redirect_to admin_dashboard_index_path, error: "You don't have enough permission to access <strong>#{params[:controller]}</strong>." and return unless current_user.is_super_admin?
      end

      def set_role
        @role = Role.find(params[:id])
      end
  end
end
