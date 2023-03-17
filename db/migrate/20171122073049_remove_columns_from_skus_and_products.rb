class RemoveColumnsFromSkusAndProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :skus, :price
    remove_column :skus, :stocks
    remove_column :products, :total_stocks
  end
end
