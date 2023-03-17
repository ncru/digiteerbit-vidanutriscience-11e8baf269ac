class AddPaypalPayerIdInOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :paypal_payer_id, :string
  end
end
