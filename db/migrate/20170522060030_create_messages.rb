class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, force: true do |t|
      t.string   :name
      t.string   :email, null: false
      t.string   :mobile
      t.string   :subject
      t.text     :content
      t.timestamps
    end
  end
end
