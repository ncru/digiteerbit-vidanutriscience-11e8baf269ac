class AddUniqueIndexOnNameAndDivisionIdToSubDivisions < ActiveRecord::Migration[5.0]
  def change
    add_index :sub_divisions, [:name, :division_id], unique: true
  end
end
