class ChangeSkuWeightColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :skus, :weight, :decimal, using: "weight::numeric"
  end
end
