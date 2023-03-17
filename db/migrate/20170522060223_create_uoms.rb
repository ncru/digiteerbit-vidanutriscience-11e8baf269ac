class CreateUoms < ActiveRecord::Migration[5.0]
  def change
    create_table :uoms do |t|
      t.string     :name, null: false
      t.string     :unit, null: false
      t.integer    :status
      t.references :uom_label, foreign_key: true
      t.timestamps
    end
  end
end
