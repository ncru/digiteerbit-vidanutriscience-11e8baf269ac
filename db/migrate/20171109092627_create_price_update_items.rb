class CreatePriceUpdateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :price_update_items do |t|
      t.references :price_update, foreign_key: true, null: false
      t.references :sku, foreign_key: true, null: false
      t.decimal :price
      t.decimal :promo_price
    end
  end
end
