class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, foreign_key: true, null: false
      t.references :sku, foreign_key: true, null: false
      t.integer    :quantity, default: 0
      t.timestamps
    end
  end
end
