class AddCourierIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :courier_id, :integer
  end
end
