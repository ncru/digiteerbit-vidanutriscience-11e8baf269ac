class CreateAdvertisements < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisements do |t|
      t.string     :name, null: false
      t.text       :description
      t.string     :photo_url, null: false
      t.integer    :status
      t.timestamps
    end
  end
end
