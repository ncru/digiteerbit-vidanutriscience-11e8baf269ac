class AddNameUniqueIndexInSystemSettings < ActiveRecord::Migration[5.0]
  def change
    add_index :system_settings, :name, unique: true
  end
end
