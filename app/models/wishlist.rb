class Wishlist < ApplicationRecord

  belongs_to :customer
  belongs_to :sku

end
