module Admin
  class FaqsController < AdminController

    before_action :set_faq, only: [:edit, :update, :destroy]

    # GET /admin/faqs
    def index
      @faqs = Faq.for_datatables
    end

    # GET /admin/faqs/new
    def new
      @faq = Faq.new
    end

    # POST /admin/faqs
    def create
      @faq = Faq.new(faq_params)

      respond_to do |format|
        if @faq.save
          log_to_audittrail('add', 'FAQ', @faq.title)

          format.html {
            redirect_to admin_faqs_path, notice: "FAQ <strong>" + @faq.title + "</strong> has been successfully added."
          }
        else
          format.html { render :new }
        end
      end
    end

    # GET /admin/faqs/:id/edit
    def edit
    end

    # PATCH /admin/faqs/:id
    # PUT /admin/faqs/:id
    def update
      respond_to do |format|
        if @faq.update(faq_params)
          log_to_audittrail('edit', 'FAQ', @faq.title)

          format.html {
            redirect_to admin_faqs_path, notice: "FAQ <strong>" + @faq.title + "</strong> has been successfully updated."
          }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /admin/faqs/:id
    def destroy
      @faq.destroy

      respond_to do |format|
        flash[:notice] = "FAQ <strong>" + @faq.title + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'FAQ', @faq.title)

        flash.discard if Faq.for_datatables.count(1) == 0

        format.html { redirect_to admin_faqs_path }
      end
    end

    # POST /admin/datatables/retrieve_faqs
    def populate_datatables
      @faqs = build_datatable(Faq.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @faqs }
      end
    end

    private
      def faq_params
        params.require(:faq).permit(:title, :question, :answer, :status)
      end

      def set_faq
        @faq = Faq.find(params[:id])
      end
  end
end
