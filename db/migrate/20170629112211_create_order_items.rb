class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.string      :request_id, null: false
      t.references  :sku, foreign_key: true, null: false
      t.integer     :quantity, null: false
    end
    
    add_index :order_items, :request_id
  end
end
