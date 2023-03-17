class RedefineCartIdInOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :cart_id
    add_reference :orders, :cart, foreign_key: true
  end
end
