class AdditionalColumnForOrderItemAndInventory < ActiveRecord::Migration[5.1]
  def change
    add_column :inventories, :order_request_id, :string
    add_column :order_items, :price, :decimal
  end
end
