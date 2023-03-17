class CreateDhlShipperAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :dhl_shipper_accounts do |t|
      t.string      :account_number
      t.string      :shipper_id
      t.string      :company
      t.string      :address1
      t.string      :address2
      t.string      :city
      t.string      :postal_code
      t.string      :country_code
      t.string      :contact_person
      t.string      :contact_no
      t.string      :default_product_code
      t.string      :default_package_type
      t.time        :ready_time
      t.time        :close_time
      t.integer     :status
    end
  end
end
