class CreateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table   :provinces do |t|
      t.string     :code
      t.string     :name
      t.integer    :status, default: 1
      t.references :country, foreign_key: true, index: true
    end
    
    add_index :provinces, :code, unique: true
    add_index :provinces, :name, unique: true
  end
end
