# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200814150253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisements", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "photo_url", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audittrails", id: :serial, force: :cascade do |t|
    t.string "module", limit: 100, null: false
    t.text "event_description", null: false
    t.inet "ip_address", null: false
    t.string "modified_by_email", null: false
    t.string "modified_by_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "photo_url"
    t.string "slug"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "banner_photo_url"
  end

  create_table "careers", id: :serial, force: :cascade do |t|
    t.string "position", limit: 100, null: false
    t.text "description", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", id: :serial, force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "sku_id", null: false
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["sku_id"], name: "index_cart_items_on_sku_id"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 1
    t.bigint "province_id"
    t.index ["name"], name: "index_cities_on_name"
    t.index ["province_id"], name: "index_cities_on_province_id"
  end

  create_table "company_details", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "code"], name: "index_countries_on_name_and_code", unique: true
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "mobile"
    t.string "provider"
    t.string "uid"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country_code"
    t.string "zip_code"
    t.string "shipping_address1"
    t.string "shipping_address2"
    t.string "shipping_city"
    t.string "shipping_state"
    t.string "shipping_country_code"
    t.string "shipping_zip_code"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "dhl_package_types", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "status"
  end

  create_table "dhl_products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "content_code"
    t.string "doc_or_nondoc"
    t.integer "status"
  end

  create_table "dhl_response_values", force: :cascade do |t|
    t.text "label_image_base64"
    t.string "awb_number"
    t.string "confirmation"
    t.bigint "order_id"
    t.string "product_code"
    t.string "package_type"
    t.date "pickup_date"
    t.index ["order_id"], name: "index_dhl_response_values_on_order_id"
  end

  create_table "dhl_shipper_accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "shipper_id"
    t.string "company"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "postal_code"
    t.string "country_code"
    t.string "contact_person"
    t.string "contact_no"
    t.integer "status"
    t.string "default_product_code"
    t.string "default_package_type"
    t.time "ready_time"
    t.time "close_time"
  end

  create_table "divisions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "question", null: false
    t.text "answer", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_request_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "sku_id", null: false
    t.integer "quantity", null: false
    t.integer "action_id", default: 0
    t.integer "status_id"
    t.string "remarks"
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id"
    t.index ["sku_id"], name: "index_inventory_items_on_sku_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "mobile"
    t.string "subject"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_newsletter_subscribers_on_email", unique: true
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.string "request_id", null: false
    t.integer "sku_id", null: false
    t.integer "quantity", null: false
    t.decimal "price"
    t.index ["request_id"], name: "index_order_items_on_request_id"
    t.index ["sku_id"], name: "index_order_items_on_sku_id"
  end

  create_table "order_status_updates", id: :serial, force: :cascade do |t|
    t.string "request_id", null: false
    t.integer "order_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_status_id"], name: "index_order_status_updates_on_order_status_id"
    t.index ["request_id"], name: "index_order_status_updates_on_request_id"
  end

  create_table "order_statuses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.string "color_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.integer "courier_id", default: -1
    t.integer "dhl_service_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.string "request_id"
    t.string "email"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country_code"
    t.string "zip_code"
    t.string "phone"
    t.string "mobile"
    t.decimal "amount"
    t.string "currency"
    t.string "promo_code"
    t.integer "complete", default: 0
    t.integer "is_same_shipping_address", default: 0
    t.string "shipping_address1"
    t.string "shipping_address2"
    t.string "shipping_city"
    t.string "shipping_state"
    t.string "shipping_country_code"
    t.string "shipping_zip_code"
    t.integer "promo_code_claimed", default: 0
    t.integer "stocks_deducted", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "paypal_token"
    t.string "paypal_payer_id"
    t.integer "order_status_id"
    t.integer "cart_id"
    t.integer "payment_method_id"
    t.decimal "shipping_fee", default: "0.0"
    t.integer "courier_id"
    t.integer "shipping_state_id"
    t.integer "shipping_city_id"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["request_id"], name: "index_orders_on_request_id", unique: true
  end

  create_table "paynamics_responses", force: :cascade do |t|
    t.string "request_id"
    t.string "merchantid"
    t.string "response_id"
    t.string "rebill_id"
    t.string "token_id"
    t.text "signature"
    t.string "ptype"
    t.string "token_info"
    t.string "response_code"
    t.text "response_message"
    t.text "response_advise"
    t.string "processor_response_id"
    t.string "processor_response_authcode"
    t.string "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_paynamics_responses_on_request_id", unique: true
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.string "photo_url"
  end

  create_table "price_update_items", force: :cascade do |t|
    t.bigint "price_update_id", null: false
    t.bigint "sku_id", null: false
    t.decimal "price"
    t.decimal "promo_price"
    t.index ["price_update_id"], name: "index_price_update_items_on_price_update_id"
    t.index ["sku_id"], name: "index_price_update_items_on_sku_id"
  end

  create_table "price_updates", force: :cascade do |t|
    t.string "promo_name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "has_no_end_date", default: 0
    t.integer "price_type", default: 0
    t.integer "sale_type", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privacy_policies", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_faqs", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "question", null: false
    t.text "answer", null: false
    t.integer "status"
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_faqs_on_product_id"
  end

  create_table "product_reviews", id: :serial, force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "product_id", null: false
    t.integer "rating", default: 0
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_product_reviews_on_customer_id"
    t.index ["product_id"], name: "index_product_reviews_on_product_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "status"
    t.string "slug"
    t.text "tags", default: [], array: true
    t.integer "brand_id", null: false
    t.integer "division_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "background_photo"
    t.string "photo"
    t.text "long_description"
    t.text "size"
    t.text "dimensions"
    t.text "weight"
    t.text "ingredients"
    t.text "policy"
    t.integer "sub_division_ids", default: [], array: true
    t.string "restricted_country_codes", default: [], array: true
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["division_id"], name: "index_products_on_division_id"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["sub_division_ids"], name: "index_products_on_sub_division_ids", using: :gin
  end

  create_table "provinces", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "status", default: 1
    t.bigint "country_id"
    t.index ["code"], name: "index_provinces_on_code", unique: true
    t.index ["country_id"], name: "index_provinces_on_country_id"
    t.index ["name"], name: "index_provinces_on_name", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_details", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_rates", force: :cascade do |t|
    t.string "country_codes", default: [], array: true
    t.decimal "kg0p5"
    t.decimal "kg1p0"
    t.decimal "kg1p5"
    t.decimal "kg2p0"
    t.decimal "kg2p5"
    t.decimal "kg3p0"
    t.decimal "kg3p5"
    t.decimal "kg4p0"
    t.decimal "kg4p5"
    t.decimal "kg5p0"
    t.decimal "kg5p5"
    t.decimal "kg6p0"
    t.decimal "kg6p5"
    t.decimal "kg7p0"
    t.decimal "kg7p5"
    t.decimal "kg8p0"
    t.decimal "kg8p5"
    t.decimal "kg9p0"
    t.decimal "kg9p5"
    t.decimal "kg10p0"
    t.decimal "kg_add_on"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skus", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.integer "new", default: 0
    t.integer "featured", default: 0
    t.integer "status"
    t.text "tags", default: [], array: true
    t.text "photos", default: [], array: true
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight"
    t.integer "minimum_quantity", default: 0
    t.index ["code"], name: "index_skus_on_code", unique: true
    t.index ["photos"], name: "index_skus_on_photos", using: :gin
    t.index ["product_id"], name: "index_skus_on_product_id"
    t.index ["tags"], name: "index_skus_on_tags", using: :gin
  end

  create_table "sliders", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "excerpt"
    t.string "photo_url"
    t.string "mobile_photo_url"
    t.integer "status"
    t.string "external_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile_photo_url"], name: "index_sliders_on_mobile_photo_url"
    t.index ["photo_url"], name: "index_sliders_on_photo_url"
  end

  create_table "sub_divisions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.integer "division_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_sub_divisions_on_division_id"
    t.index ["name", "division_id"], name: "index_sub_divisions_on_name_and_division_id", unique: true
  end

  create_table "system_settings", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "value"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_system_settings_on_name", unique: true
  end

  create_table "terms", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uom_labels", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uoms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "unit", null: false
    t.integer "status"
    t.integer "uom_label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uom_label_id"], name: "index_uoms_on_uom_label_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country_code"
    t.string "zip_code"
    t.string "phone"
    t.string "mobile"
    t.integer "role_id", default: 2
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "wishlists", id: :serial, force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "sku_id", null: false
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_wishlists_on_customer_id"
    t.index ["sku_id"], name: "index_wishlists_on_sku_id"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "skus"
  add_foreign_key "carts", "customers"
  add_foreign_key "cities", "provinces"
  add_foreign_key "dhl_response_values", "orders"
  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "inventory_items", "skus"
  add_foreign_key "order_items", "skus"
  add_foreign_key "order_status_updates", "order_statuses"
  add_foreign_key "price_update_items", "price_updates"
  add_foreign_key "price_update_items", "skus"
  add_foreign_key "product_faqs", "products"
  add_foreign_key "product_reviews", "customers"
  add_foreign_key "product_reviews", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "divisions"
  add_foreign_key "provinces", "countries"
  add_foreign_key "skus", "products"
  add_foreign_key "sub_divisions", "divisions"
  add_foreign_key "uoms", "uom_labels"
  add_foreign_key "users", "roles"
  add_foreign_key "wishlists", "customers"
  add_foreign_key "wishlists", "skus"
end
