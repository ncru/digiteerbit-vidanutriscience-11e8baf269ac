class CreateDhlResponseValues < ActiveRecord::Migration[5.1]
  def change
    create_table :dhl_response_values do |t|
      t.text    :label_image_base64
      t.string  :awb_number
      t.string  :confirmation
      t.string  :product_code
      t.string  :package_type
    end
    
    add_reference :dhl_response_values, :order, foreign_key: true
  end
end
