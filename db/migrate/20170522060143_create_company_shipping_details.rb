class CreateCompanyShippingDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_details do |t|
      t.text       :content
      t.timestamps
    end
  end
end
