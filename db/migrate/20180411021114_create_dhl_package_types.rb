class CreateDhlPackageTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :dhl_package_types do |t|
      t.string      :code
      t.string      :name
      t.integer     :status
    end
  end
end
