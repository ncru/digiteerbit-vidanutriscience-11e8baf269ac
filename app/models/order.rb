class Order < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
  require 'dhl/get_quote'
  # Associations.
  belongs_to :customer
  belongs_to :cart
  belongs_to :order_status
  
  has_many       :order_items, -> { order("id desc") }, 
    dependent:   :destroy, 
    foreign_key: :request_id, 
    primary_key: :request_id
    
  has_many       :order_status_updates, -> { order("id desc") }, 
    dependent:   :destroy, 
    foreign_key: :request_id, 
    primary_key: :request_id
  
  has_one        :dhl_response_value
  
    validates            :first_name, presence: true
    validates            :last_name, presence: true
    validates            :shipping_address1, presence: true, length: {:minimum => 1, :maximum => 42}
    validates            :shipping_address2, presence: false, length: {:minimum => 1, :maximum => 42}
    validates            :shipping_country_code, presence: true
    validates            :shipping_zip_code, presence: true
    validate             :restricted_products, on: :create
    
  # Callback methods.
  after_create :insert_order_items
  after_update :insert_status_update

  scope :for_datatables, -> {
    select(" os.color_code, o.id, o.request_id, o.created_at, o.updated_at, (o.amount + o.shipping_fee) as amount, o.order_status_id, os.name, o.courier_id, os.dhl_service_id, os.level")
    .from("orders o 
      JOIN order_statuses os ON o.order_status_id = os.id 
      LEFT OUTER JOIN customers c ON o.customer_id = c.id")
  }
  
  scope :order_item_details, -> (request_id) {
    select("oi.id, p.name AS product_name, s.name AS sku_name, s.photos[1] AS photo_url, 
      oi.quantity, oi.price")
    .from("orders o 
      JOIN order_items oi ON o.request_id = oi.request_id
      JOIN skus s ON oi.sku_id = s.id
      JOIN products p ON s.product_id = p.id")
    .where("o.request_id = ?", request_id)
  }
  
  # Store the order items.
  def insert_order_items
    cart.cart_items.each do |item| 
      order_items.create(
        request_id: self.request_id,
        sku_id:     item.sku.id,
        quantity:   item.quantity,
        price:      item.sku.get_price
      )
    end
  end
  
  # Insert an entry of order status update if the order status id is changed.
  def insert_status_update
    if saved_change_to_order_status_id?
      order_status_updates.create(
        request_id:      self.request_id,
        order_status_id: self.order_status_id
      )
    end
  end

  def shipping_address
    self.shipping_address1.to_s + ", " +
    self.shipping_address2.to_s + ", " +
    self.shipping_city.to_s + ", " + 
    self.shipping_state.to_s + ", " + 
    self.shipping_zip_code.to_s + ", " + 
    Country.find_by(code: self.shipping_country_code).name.to_s
  end

  def get_html_order_details
    prefix = '<table border="0" cellpadding="0" cellspacing="0" style="width: 100%; max-width: 100%; border-collapse: collapse; border-spacing: 0;">
      <tbody>'

    # Include the purchased items.
    order_items.each do |item|
      prefix << %Q[
        <tr style="border-bottom: 1px solid #000000;">
          <td style="border-top: none !important; vertical-align: top !important; padding: 15px 5px; text-align: left;width: 25%;">
            <img src="#{item.sku.photo}" style="max-width: 100%;"/>
          </td>
          <td style="border-top: none !important; vertical-align: top !important; padding: 15px 5px; text-align: left;width: 40%;">
            <div><strong>PRODUCT</strong></div>
            <div>#{item.sku.product.name}</div>
            <div><small>#{item.sku.name}<small></div>
          </td>
          <td style="border-top: none !important; vertical-align: top !important; padding: 15px 5px; text-align: left;width: 15%;">
            <div><strong>Qty.</strong></div>
            <div>#{item.quantity}</div>
          </td>
          <td style="border-top: none !important; vertical-align: top !important; padding: 15px 5px; text-align: left;width: 20%;">
            <div><strong>Price</strong></div>
            <div>₱#{format_number_with_precision(item.sku.get_price, 2)}</div>
          </td>
        </tr>
      ]
    end

    prefix
  end
  
  def total_weight
    order_items.collect { |ci| ci.quantity * ci.sku.weight.to_f }.sum
  end
  
  def get_dhl_shipping_fee_response
    request = GetQuoteRequest.new
    
    request.metric_measurements!

    # r.add_special_service("DD")
    
    request.to(self.shipping_country_code, self.shipping_zip_code)
    request.from('PH', 1106) # Vida NutriScience's country code and zip code 
    
    request.pieces << GetQuotePiece.new(:weight => self.cart.total_weight)

    response = request.post
  end
  private
    def restricted_products
      @restricted_sku_ids = []
      self.cart.cart_items.each do |ci|
        @restricted_sku_ids << ci.sku.id if ci.sku.product.restricted_country_codes.include? self.shipping_country_code
      end
      errors.add(:base, "Some products does not ship to " + Country.find_by_code(self.shipping_country_code).name.to_s) if @restricted_sku_ids.present?
    end
    
end
