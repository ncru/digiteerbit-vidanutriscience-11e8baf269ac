class CreateOrderStatusUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table    :order_status_updates do |t|
      t.string      :request_id, null: false
      t.references  :order_status, foreign_key: true, null: false
      t.timestamps
    end
    
    add_index :order_status_updates, :request_id
  end
end
