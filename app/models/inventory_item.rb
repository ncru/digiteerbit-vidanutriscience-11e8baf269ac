class InventoryItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :sku
  validates :action_id, presence: { message: "is required."}
  validates :quantity, numericality: true
end
