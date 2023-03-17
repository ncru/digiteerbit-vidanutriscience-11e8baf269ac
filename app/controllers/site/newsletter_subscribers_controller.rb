module Site
  class NewsletterSubscribersController < SiteController

    def create
      @newsletter_subscriber = NewsletterSubscriber.new(newsletter_subscriber_params)

      unless @newsletter_subscriber.save
        render action: "error"
      end
    end

    private
      def newsletter_subscriber_params
        params.require(:newsletter_subscriber).permit(:email)
      end
  end
end
