module Admin
  class TermsController < AdminController

    before_action :set_term, only: [:edit, :update]

    # GET /admin/terms
    def index
      redirect_to new_admin_term_path and return unless Term.first.present?

      @term = Term.first
    end

    # GET /admin/terms/new
    def new
      @term = Term.new
    end

    # POST /admin/terms
    def create
      @term = Term.new(term_params)

      respond_to do |format|
        if @term.save
          log_to_audittrail('add', 'TERMS', '')

          format.html {
            redirect_to admin_terms_path, notice: "Terms has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/terms/:id/edit
    def edit
    end

    # PATCH /admin/terms/:id
    # PUT /admin/terms/:id
    def update
      respond_to do |format|
        if @term.update(term_params)
          log_to_audittrail('edit', 'TERMS', '')

          format.html {
            redirect_to admin_terms_path, notice: "Terms has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    private
      def term_params
        params.require(:term).permit(:content)
      end

      def set_term
        @term = Term.find(params[:id])
      end
  end
end
