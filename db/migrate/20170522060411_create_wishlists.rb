class CreateWishlists < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlists do |t|
      t.references :customer, foreign_key: true, null: false
      t.references :sku, foreign_key: true, null: false
      t.integer    :status, default: 1
      t.timestamps
    end
  end
end
