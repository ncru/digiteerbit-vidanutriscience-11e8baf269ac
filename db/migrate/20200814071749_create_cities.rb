class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table   :cities do |t|
      t.string     :name
      t.integer    :status, default: 1
      t.references :province, foreign_key: true, index: true
    end
    
    add_index :cities, :name
  end
end
