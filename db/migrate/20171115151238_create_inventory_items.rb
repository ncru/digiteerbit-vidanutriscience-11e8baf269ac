class CreateInventoryItems < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_items do |t|
      t.references  :inventory, foreign_key: true, null: false
      t.references  :sku, foreign_key: true, null: false
      t.integer     :quantity, null: false
      t.integer     :action_id, default: 0   
      t.integer     :status_id
      t.string      :remarks
    end
  end
end
