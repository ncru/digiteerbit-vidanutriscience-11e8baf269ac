class PriceUpdateItem < ApplicationRecord
  belongs_to :price_update
  belongs_to :sku
  validates :price, numericality: true
end
