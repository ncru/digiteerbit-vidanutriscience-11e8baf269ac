class AddPaypalTokenInOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :paypal_token, :string
  end
end
