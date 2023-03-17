module Admin
  class PrivacyPoliciesController < AdminController

    before_action :set_privacy_policy, only: [:edit, :update]

    # GET /admin/privacy-policy
    def index
      redirect_to new_admin_privacy_policy_path and return unless PrivacyPolicy.first.present?

      @privacy_policy = PrivacyPolicy.first
    end

    # GET /admin/privacy-policy/new
    def new
      @privacy_policy = PrivacyPolicy.new
    end

    # POST /admin/privacy-policy
    def create
      @privacy_policy = PrivacyPolicy.new(privacy_policy_params)

      respond_to do |format|
        if @privacy_policy.save
          log_to_audittrail('add', 'PRIVACY POLICY', '')

          format.html {
            redirect_to admin_privacy_policies_path, notice: "Privacy Policy has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/privacy-policy/:id/edit
    def edit
    end

    # PATCH /admin/privacy-policy/:id
    # PUT /admin/privacy-policy/:id
    def update
      respond_to do |format|
        if @privacy_policy.update(privacy_policy_params)
          log_to_audittrail('edit', 'PRIVACY POLICY', '')

          format.html {
            redirect_to admin_privacy_policies_path, notice: "Privacy Policy has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    private
      def privacy_policy_params
        params.require(:privacy_policy).permit(:content)
      end

      def set_privacy_policy
        @privacy_policy = PrivacyPolicy.find(params[:id])
      end
  end
end
