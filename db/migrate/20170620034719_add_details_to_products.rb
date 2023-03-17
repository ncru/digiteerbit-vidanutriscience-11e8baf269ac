class AddDetailsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :background_photo, :string
    add_column :products, :photo, :string
    add_column :products, :long_description, :text
    add_column :products, :size, :text
    add_column :products, :dimensions, :text
    add_column :products, :weight, :text
    add_column :products, :ingredients, :text
    add_column :products, :policy, :text
  end
end
