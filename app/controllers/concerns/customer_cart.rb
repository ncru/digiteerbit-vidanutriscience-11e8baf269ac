module CustomerCart
  extend ActiveSupport::Concern

  included do
    before_action :set_cart
  end

  private
    def set_cart
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = customer_signed_in? ? current_customer.carts.create : Cart.create
      session[:cart_id] = @cart.id
    end
end
