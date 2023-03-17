class CreateSystemSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :system_settings do |t|
      t.string   :name, null: false
      t.string   :value
      t.integer  :status
      t.timestamps
    end
  end
end
