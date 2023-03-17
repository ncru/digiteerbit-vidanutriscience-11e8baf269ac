class Inventory < ApplicationRecord
  has_many :inventory_items, :foreign_key => :inventory_id, dependent: :destroy
  accepts_nested_attributes_for :inventory_items, allow_destroy: true, reject_if: :all_blank

  scope :for_datatables, -> {
    select("s.id, (case when s.photos[1] is null then 'https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg' else s.photos[1] end) as photo_url, s.name, ((case when r.remaining_stocks is null then 0 else r.remaining_stocks end)-(case when d.deducted is null then 0 else d.deducted end)) as stocks")
      .from("skus s 
        LEFT JOIN (SELECT s.id as sku_id, sum(ii.quantity) as remaining_stocks from skus s JOIN inventory_items ii ON s.id = ii.sku_id WHERE action_id = 1 GROUP BY s.id) r ON r.sku_id = s.id
        LEFT JOIN (SELECT s.id as sku_id, sum(ii.quantity) as deducted from skus s JOIN inventory_items ii ON s.id = ii.sku_id WHERE action_id = 2 GROUP BY s.id) d ON d.sku_id = r.sku_id
      ")
  }
  
  scope :for_show_datatables, -> (sku_id) {
    select("i.created_at, i.order_request_id as request_id, concat(u.first_name, ' ',u.last_name) as filed_by, ii.quantity, ii.action_id, ii.remarks")
      .from("inventories i JOIN inventory_items ii ON i.id = ii.inventory_id LEFT JOIN users u ON u.id = i.user_id")
      .where("ii.sku_id = ?", sku_id)
      .order("i.created_at desc")
  }
  
  scope :latest_today, -> (user_id) {
    select("i.id").
      from("inventories i 
            JOIN inventory_items ii ON i.id = ii.inventory_id 
            JOIN skus s ON ii.sku_id = s.id
          ").
      where("i.order_request_id is null OR i.order_request_id = ''").
      where("i.created_at::timestamp::date = CURRENT_DATE").
      where("i.user_id = ?", user_id)
  }
  
  def update_product_stocks(order)
    order.order_items.each do |item| 
      inventory_items.create(
        sku_id:     item.sku.id,
        quantity:   item.quantity,
        action_id:  2, # deduct
        remarks:    'Sold' 
      )
    end
  end
end
