class CartItem < ApplicationRecord

  belongs_to :cart
  belongs_to :sku

  validates :quantity, numericality: true
  validate :minimum_cart_item

  # Get the subtotal of this item.
  def subtotal
    self.quantity * self.sku.get_price
  end
  
  def minimum_cart_item
      errors.add(:base, new_record? ? "You are trying to purchase <strong>"+self.quantity.to_s+"</strong> but we can only accommodate at least <strong>"+self.sku.minimum_quantity.to_s+"</strong> for this item." : "At least "+self.sku.minimum_quantity.to_s+" items are required.") if self.sku.minimum_quantity.to_i > self.quantity.to_i
  end
end
