class CreateShippingRates < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_rates do |t|
      t.string  :country_codes, array: true, default: []
      t.decimal :kg0p5
      t.decimal :kg1p0
      t.decimal :kg1p5
      t.decimal :kg2p0
      t.decimal :kg2p5
      t.decimal :kg3p0
      t.decimal :kg3p5
      t.decimal :kg4p0
      t.decimal :kg4p5
      t.decimal :kg5p0
      t.decimal :kg5p5
      t.decimal :kg6p0
      t.decimal :kg6p5
      t.decimal :kg7p0
      t.decimal :kg7p5
      t.decimal :kg8p0
      t.decimal :kg8p5
      t.decimal :kg9p0
      t.decimal :kg9p5
      t.decimal :kg10p0
      t.decimal :kg_add_on
      t.integer :status
      t.timestamps
    end
    
    add_column :products, :restricted_country_codes, :string, array: true, default: []
    add_column :orders, :shipping_fee, :decimal, default: 0
  end
end
