class CreateSliders < ActiveRecord::Migration[5.0]
  def change
    create_table :sliders, force: true do |t|
      t.string   :title, null: false
      t.text     :excerpt
      t.string   :photo_url
      t.string   :mobile_photo_url
      t.integer  :status
      t.string   :external_link
      t.timestamps
    end

    add_index :sliders, :photo_url
    add_index :sliders, :mobile_photo_url
  end
end
