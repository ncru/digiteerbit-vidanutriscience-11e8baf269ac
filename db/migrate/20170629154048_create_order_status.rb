class CreateOrderStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :order_statuses do |t|
      t.string   :name, null: false
      t.integer  :status
      t.string   :color_code
      t.timestamps
    end
  end
end
