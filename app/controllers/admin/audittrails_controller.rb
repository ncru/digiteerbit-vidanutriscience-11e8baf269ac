module Admin
  class AudittrailsController < AdminController

    # GET /admin/audittrails
    def index
      redirect_to admin_dashboard_index_path, error: "You don't have enough permission to access <strong>#{params[:controller]}</strong>." and return unless current_user.is_super_admin? || current_user.is_admin?

      @audittrails = Audittrail.for_datatables
    end

    # POST /admin/datatables/retrieve_audittrails
    def populate_datatables
      @audittrails = build_datatable(Audittrail.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @audittrails }
      end
    end
  end
end
