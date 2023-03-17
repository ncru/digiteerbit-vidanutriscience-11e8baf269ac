class AddRequestIdUniqueIndexInOrders < ActiveRecord::Migration[5.0]
  def change
    add_index :orders, :request_id, unique: true
  end
end
