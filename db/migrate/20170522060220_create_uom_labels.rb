class CreateUomLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :uom_labels do |t|
      t.string   :name, null: false
      t.integer  :status
      t.timestamps
    end
  end
end
