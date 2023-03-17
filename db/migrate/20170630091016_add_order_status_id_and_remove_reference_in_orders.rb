class AddOrderStatusIdAndRemoveReferenceInOrders < ActiveRecord::Migration[5.0]
  def change
    remove_reference :orders, :order_status
    add_column       :orders, :order_status_id, :integer
    
    add_index        :orders, :order_status_id
  end
end
