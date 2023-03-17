class CreateSubDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table    :sub_divisions do |t|
      t.string      :name, null: false
      t.integer     :status
      t.references  :division, foreign_key: true, null: false
      t.timestamps
    end
  end
end
