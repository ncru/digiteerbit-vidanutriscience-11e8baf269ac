class OrderItem < ApplicationRecord

  belongs_to :order, foreign_key: :request_id
  belongs_to :sku

  validates :quantity, numericality: true

  # Get the subtotal of this item.
  
  scope :for_adwords, -> (order_request_id) {
    select("s.name as sku_name, s.code as sku_code, oi.quantity, oi.price, d.name as category")
    .from("orders o JOIN order_items oi ON o.request_id = oi.request_id 
          JOIN skus s ON oi.sku_id = s.id 
          JOIN products p on s.product_id = p.id
          JOIN divisions d on p.division_id = d.id"
         )
    .where("o.request_id = ?", order_request_id)
  }
  
  def subtotal
    self.quantity * self.price
  end
end
