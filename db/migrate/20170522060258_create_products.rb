class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string      :name, null: false
      t.text        :description
      t.integer     :status
      t.string      :slug
      t.text        :tags, default: [], array: true
      t.integer     :total_stocks
      t.references  :brand, foreign_key: true, null: false
      t.references  :division, foreign_key: true, null: false
      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
