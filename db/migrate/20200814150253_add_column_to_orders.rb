class AddColumnToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :shipping_state_id, :integer
    add_column :orders, :shipping_city_id, :integer
  end
end
