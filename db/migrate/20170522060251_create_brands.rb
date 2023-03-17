class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string   :name, null: false
      t.text     :description
      t.string   :photo_url
      t.string   :slug
      t.integer  :status
      t.timestamps
    end
  end
end
