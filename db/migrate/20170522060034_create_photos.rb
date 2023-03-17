class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos, force: true do |t|
      t.string :photo_url
    end
  end
end
