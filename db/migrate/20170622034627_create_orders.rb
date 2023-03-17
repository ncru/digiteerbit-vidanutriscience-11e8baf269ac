class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer "customer_id"
      t.string  "request_id"
      t.string  "email"
      t.string  "first_name"
      t.string  "middle_name"
      t.string  "last_name"
      t.string  "address1"
      t.string  "address2"
      t.string  "city"
      t.string  "state"
      t.string  "country_code"
      t.string  "zip_code"
      t.string  "phone"
      t.string  "mobile"
      t.decimal "amount"
      t.string  "currency"
      t.string  "promo_code"
      t.integer "complete",                 default: 0
      t.integer "cart_id"
      t.integer "is_same_shipping_address", default: 0
      t.string  "shipping_address1"
      t.string  "shipping_address2"
      t.string  "shipping_city"
      t.string  "shipping_state"
      t.string  "shipping_country_code"
      t.string  "shipping_zip_code"
      t.integer "promo_code_claimed",       default: 0
      t.integer "stocks_deducted",          default: 0
    end
  end
end
