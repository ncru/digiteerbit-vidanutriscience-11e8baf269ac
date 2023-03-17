class AddCustomerDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :first_name,:string, null: false
    add_column :customers, :last_name,:string, null: false
    add_column :customers, :middle_name,:string
    add_column :customers, :mobile, :string
    add_column :customers, :provider, :string
    add_column :customers, :uid, :string
    add_attachment :customers, :photo
  end
end
