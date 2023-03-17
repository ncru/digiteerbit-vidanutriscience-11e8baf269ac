class CreatePriceUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :price_updates do |t|
      t.string   :promo_name
      t.datetime :start_date
      t.datetime :end_date
      t.integer  :has_no_end_date, default: 0
      t.integer  :price_type, default: 0
      t.integer  :sale_type, default: 0
      t.integer  :user_id
      t.timestamps
    end
  end
end
