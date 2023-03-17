class Cart < ApplicationRecord

  belongs_to :customer
  has_one    :order, -> { order("id desc") }, dependent: :nullify
  has_many   :cart_items, -> { order("id desc") }, dependent: :destroy

  #
  # Adds a new item to the cart or update current item if already existing.
  # @param product_args
  #
  def add_item(product_args)
    current_item = cart_items.find_by_sku_id(product_args[:sku_id])

    if current_item
      current_item.quantity += product_args[:quantity].to_i
      current_item.save
    else
      current_item = cart_items.build(product_args)
    end

    current_item
  end

  #
  # Updates the quantity of the item in the cart or update current item if already existing.
  # @param sku_id
  # @param quantity
  #
  def update_item(cart_item, method)
    quantity = cart_item.quantity

    case method
      when 'deduct'
        quantity = quantity - 1
        return if quantity < 1

      when 'add'
        available_stocks = cart_item.sku.get_stocks
        quantity = quantity + 1
        return if quantity > available_stocks
    end

    cart_item.update(quantity: quantity)
  end
  
  # This will build the JSON array object that will be submitted to Paypal Express Checkout.
  def express_checkout_items
    items = []
    cart_items.each do |item|
      items << {
        name:        item.sku.product.name,
        description: item.sku.name,
        quantity:    item.quantity.to_i,
        amount:      item.sku.get_price.to_f * 100
      }
    end
    items
  end
  
  # Get the total number of items inside the cart.
  def item_count
    ActionController::Base.helpers.pluralize(total_item_count, 'Item')
  end

  # Get the subtotal of all items inside the cart.
  def subtotal
    cart_items.collect { |ci| ci.quantity * ci.sku.get_price }.sum
  end
  
  def total_item_count
    cart_items.collect { |ci| ci.quantity }.sum
  end
  
  def total_weight
    cart_items.collect { |ci| ci.quantity * ci.sku.weight.to_f }.sum
  end

  # Return the number of items present in the cart for the specified SKU.
  # @param sku_id
  #
  def count_sku(sku_id)
    cart_item = cart_items.find_by_sku_id(sku_id)
    return cart_item ? cart_item.quantity : 0
  end

  # Check if the cart has items.
  def empty?
    cart_items.size == 0
  end
  
  def payment_with_paypal(ip, token, paypal_payer_id)
    total = (self.subtotal.to_f + self.order.shipping_fee.to_f) * 100
    response = EXPRESS_GATEWAY.purchase(total, {ip: ip, token: token, payer_id: paypal_payer_id, currency: 'PHP'})
    if !response.success?
      self.errors.add :base, response.message
    end
    response.success?
  end

end
