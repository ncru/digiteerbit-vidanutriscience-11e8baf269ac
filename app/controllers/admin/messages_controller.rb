module Admin
  class MessagesController < AdminController

    before_action :set_message, only: [:show, :destroy]

    # GET /admin/messages
    def index
      @messages = Message.for_datatables
    end

    # GET /admin/messages/:id
    def show
    end

    # DELETE /admin/messages/:id
    def destroy
      @message.destroy

      respond_to do |format|
        flash[:notice] = "The message from <strong>" + @message.name + "[" + @message.email + "]</strong> has been successfully deleted."
        log_to_audittrail('delete', 'MESSAGE', @message.email)

        flash.discard if Message.for_datatables.count(1) == 0

        format.html { redirect_to admin_messages_path }
      end
    end

    # POST /admin/datatables/retrieve_messages
    def populate_datatables
      @messages = build_datatable(Message.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @messages }
      end
    end

    private
      def set_message
        @message = Message.find(params[:id])
      end
  end
end
