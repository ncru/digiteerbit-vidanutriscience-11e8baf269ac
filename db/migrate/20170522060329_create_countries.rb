class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string  :name, null: false
      t.string  :code, null: false
      t.integer :status
      t.timestamps
    end

    add_index :countries, [:name, :code], unique: true
  end
end
