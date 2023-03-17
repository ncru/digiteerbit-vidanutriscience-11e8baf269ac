class AddUserDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :middle_name, :string
    add_attachment :users, :photo
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country_code, :string
    add_column :users, :zip_code, :string
    add_column :users, :phone, :string
    add_column :users, :mobile, :string
    add_reference :users, :role, foreign_key: true, default: 2
  end
end
