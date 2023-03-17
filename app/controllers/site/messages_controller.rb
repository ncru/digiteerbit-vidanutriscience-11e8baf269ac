module Site
  class MessagesController < SiteController

    def create
      @message = Message.new(message_params)

      unless @message.save
        render action: "error"
      end
    end

    private
      def message_params
        params.require(:message).permit(:name, :email, :mobile, :subject, :content)
      end
  end
end
