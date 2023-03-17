module Admin
  class DashboardController < AdminController

    # GET /admin/dashboard
    def index
      @last_30days_msg_count = Message.last_30days_messages.count(1)
      # @total_newsletter_subscribers_count = NewsletterSubscriber.count(1)
      @active_products_count = Product.active_products_count.count(1)
      # @last_7days_orders_count = Order.last_7days_orders.count(1)
      @recent_changes = Audittrail.recent_changes
      @latest_messages = Message.latest_messages
    end
  end
end
