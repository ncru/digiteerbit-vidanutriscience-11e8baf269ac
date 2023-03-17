class Sku < ApplicationRecord

  belongs_to :product
  has_many   :cart_items, dependent: :destroy
  has_many   :order_items
  has_many   :inventory_items,                     dependent: :destroy, foreign_key: :sku_id
  has_many   :price_update_items, -> { order("id desc") },  dependent: :destroy, foreign_key: :sku_id
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }
  accepts_nested_attributes_for :price_update_items, allow_destroy: true, reject_if: proc { |attributes| valid_price?(attributes[:price], attributes[:sku_id])}
  
  def self.valid_price?(new_price, sku_id)
    sku_price = Sku.get_sku_price(sku_id) if sku_id.present?
    return (new_price.to_f == (sku_price.present? ? sku_price.take.price : 0.0)) ? true : false
  end
  
  scope :active_skus, -> {
    select("s.id, s.name, p.slug, pui.price, pui.promo_price, pu.price_type, s.product_id, s.photos, s.new")
    .from("products p JOIN skus s ON p.id = s.product_id
          JOIN (SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today ON s.id = price_today.sku_id
          JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
          JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
    ")
    .where("p.status = 1")
    .where("s.status = 1")
    .order("pui.price DESC")
  }
  
  scope :get_sku_price,->(sku_id) {
    select("(case when pu.price_type = 1 then pui.promo_price else pui.price end) as price")
    .from("(SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today
      JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
      JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
    ")
    .where("price_today.sku_id = ?", sku_id)
    .order("price_today.created_at desc, pui.id desc")
  }
  
  scope :available_skus, -> {
    select("id, name")
    .order("name")
  }

  scope :featured_skus, -> {
    select("p.description, p.division_id, s.id, s.name, p.slug, s.product_id, s.photos")
    .from("products p JOIN skus s ON p.id = s.product_id")
    .where("p.status = 1")
    .where("s.status = 1")
    .where("s.featured =1 ")
    .order("random()")
    .limit(4)
  }

  scope :related_items_by_division, ->(division_id, sku_id) {
    select("s.id, s.name, pui.price, pui.promo_price, pu.price_type, p.slug, s.product_id, s.photos")
    .from("products p JOIN skus s ON p.id = s.product_id
      JOIN (SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today ON s.id = price_today.sku_id
      JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
      JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
      ")
    .where("p.status = 1")
    .where("s.status = 1")
    .where("p.division_id = ?", division_id)
    .where("s.id != ?", sku_id)
    .order("random()")
  }
  
  scope :related_items_by_brand, ->(brand_id, sku_id) {
    select("s.id, s.name, pui.price, pui.promo_price, pu.price_type, p.slug, s.product_id, s.photos")
    .from("products p JOIN skus s ON p.id = s.product_id
      JOIN (SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today ON s.id = price_today.sku_id
      JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
      JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
      ")
    .where("p.status = 1")
    .where("s.status = 1")
    .where("p.brand_id = ?", brand_id)
    .where("s.id != ?", sku_id)
    .order("random()")
  }
  
  scope :get_product_skus,-> (product_id) {
    select("distinct s.id, s.name, s.code, pui.price, pui.promo_price, pu.price_type")
      .from("(SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today
        JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
        JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
        JOIN skus s on s.id = pui.sku_id
      ")
      .where("s.product_id = ?", product_id)
      .order("s.id")
  }
  
  scope :search, -> (q) {
    select("s.id, s.name, p.slug, pui.price, pui.promo_price, pu.price_type,  s.product_id, s.photos, s.new")
    .from("products p JOIN skus s ON p.id = s.product_id
      JOIN (SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today ON s.id = price_today.sku_id
      JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
      JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
    ")
    .where("p.status = 1")
    .where("s.status = 1")
    .where("p.name ilike ? 
      OR s.name ilike ?
      OR array_to_string(p.tags, ',') ilike ?
      OR array_to_string(s.tags, ',') ilike ?", "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%")
    .order("pui.price DESC")
  }
  
  scope :by_brand, ->(ids) {
    where("p.brand_id IN (?)", ids)
  }

  validates :code,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  
  validates :weight, presence: { message: "is required." }

  def return_items(number_of_items_to_return)
    self.product.return_items(number_of_items_to_return)
    self.stocks += number_of_items_to_return
    self.save
  end
  
  def get_stocks
    (inventory_items.where(action_id: 1).collect {|ii| ii.quantity}.sum) - inventory_items.where(action_id: 2).collect {|ii| ii.quantity}.sum 
  end
  
  # def deduct_from_stocks(number_of_items_to_get)
  #   self.product.deduct_from_stocks(number_of_items_to_get)
  #   self.stocks -= number_of_items_to_get
  #   self.save
  # end
  # 
  # def update_stocks(new_stock_value)
  #   self.stocks = new_stock_value
  #   self.save
  #   self.product.compute_stocks
  # end
  
  def get_price
    sku_price = Sku.get_sku_price(self.id)
    sku_price.present? ? sku_price.take.price : 0.0
  end

  def delete_photos
    self.photos = nil
    self.save
  end

  def out_of_stock?
    return self.get_stocks < 1
  end

  def photo
    self.photos.nil? ? 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg'
    : self.photos[0]
  end
  
  # Return the number of items present in the cart for the specified SKU.
  # @param sku_id
  #
  def count_sku(sku_id)
    cart_item = cart_items.find_by_sku_id(sku_id)
    return cart_item ? cart_item.quantity : 0
  end
  
  def select_tag_name(cart)
    self.name + " " + "- #{self.get_stocks - cart.count_sku(self.id)}x available"
  end
end
