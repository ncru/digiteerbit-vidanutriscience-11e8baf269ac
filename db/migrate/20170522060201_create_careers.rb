class CreateCareers < ActiveRecord::Migration[5.0]
  def change
    create_table :careers do |t|
      t.string   :position, null: false, limit: 100
      t.text     :description, null: false
      t.integer  :status
      t.timestamps
    end
  end
end
