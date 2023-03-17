class AddWeightAndMinimumToSkus < ActiveRecord::Migration[5.1]
  def change
    add_column :skus, :weight, :decimal
    add_column :skus, :minimum_quantity, :integer, default: 0
  end
end
