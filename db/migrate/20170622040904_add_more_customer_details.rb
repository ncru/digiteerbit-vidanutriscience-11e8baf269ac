class AddMoreCustomerDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :address1, :string
    add_column :customers, :address2, :string
    add_column :customers, :city, :string
    add_column :customers, :state, :string
    add_column :customers, :country_code, :string
    add_column :customers, :zip_code, :string
    add_column :customers, :shipping_address1, :string
    add_column :customers, :shipping_address2, :string
    add_column :customers, :shipping_city, :string
    add_column :customers, :shipping_state, :string
    add_column :customers, :shipping_country_code, :string
    add_column :customers, :shipping_zip_code, :string
  end
end
