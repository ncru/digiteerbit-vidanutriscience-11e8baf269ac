class AddSubDivisionIdsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :sub_division_ids, :integer, default: [], array: true
    
    add_index  :products, :sub_division_ids, using: 'gin'
  end
end
