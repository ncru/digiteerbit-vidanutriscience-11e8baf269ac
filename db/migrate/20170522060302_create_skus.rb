class CreateSkus < ActiveRecord::Migration[5.0]
  def change
    create_table :skus do |t|
      t.string      :code, null: false
      t.string      :name, null: false
      t.decimal     :price, null: false
      t.integer     :stocks, default: 0
      t.integer     :new, default: 0
      t.integer     :featured, default: 0
      t.integer     :status
      t.text        :tags, default: [], array: true
      t.text        :photos, default: [], array: true
      t.references  :product, foreign_key: true, null: false
      t.timestamps
    end

    add_index :skus, :code, unique: true
    add_index :skus, :tags, using: 'gin'
    add_index :skus, :photos, using: 'gin'
  end
end
