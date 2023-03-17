class PriceUpdate < ApplicationRecord
  has_many :price_update_items, :foreign_key => :price_update_id, dependent: :destroy
  accepts_nested_attributes_for :price_update_items, allow_destroy: true, reject_if: :all_blank
  
  scope :for_datatables,-> {
    select("distinct pui.sku_id, (case when s.photos[1] is null then 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' else s.photos[1] end) as photo_url, pu.start_date, pu.end_date, pu.has_no_end_date, s.name, pui.price, (case when pu.price_type=1 then 'Sale' else '' end) as sale_text, pu.sale_type as promo_type,pui.promo_price")
      .from("(SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today
        JOIN price_update_items pui ON pui.sku_id = price_today.sku_id
        JOIN price_updates pu ON pu.id = pui.price_update_id AND price_today.created_at = pu.created_at
        JOIN skus s on s.id = pui.sku_id
      ")
  }
  
  scope :price_history, -> {
    select("s.id, (case when s.photos[1] is null then 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' else s.photos[1] end) as photo_url, s.name, pu.start_date, pu.end_date, pu.has_no_end_date, pui.price, pu.sale_type, pui.promo_price, pu.created_at, CONCAT(u.first_name, ' ', u.last_name) as full_name")
      .from("price_updates pu JOIN price_update_items pui ON pu.id = pui.price_update_id JOIN skus s ON pui.sku_id = s.id LEFT JOIN users u ON u.id = pu.user_id")
  }
  
  scope :get_regular_price,->(sku_id) {
    select("pui.price")
    .from("(SELECT pui.sku_id, MAX(pu.created_at) as created_at FROM price_updates pu JOIN price_update_items pui ON pui.price_update_id = pu.id WHERE pu.price_type = 0 AND pu.start_date <= CURRENT_DATE AND (case when pu.has_no_end_date = 1 then CURRENT_DATE + interval '1' day else pu.end_date end) >= CURRENT_DATE GROUP BY pui.sku_id) price_today JOIN price_update_items pui ON pui.sku_id = price_today.sku_id")
    .where("price_today.sku_id = ?", sku_id)
  }
  
  scope :latest_today, -> (user_id) {
    select("pu.id").
      from("price_updates pu 
            JOIN price_update_items pui ON pu.id = pui.price_update_id
          ").
      where("pu.created_at::timestamp::date = CURRENT_DATE").
      where("pu.price_type = 0").
      where("pu.has_no_end_date = 1").
      where("pu.user_id = ?", user_id)
  }
end
