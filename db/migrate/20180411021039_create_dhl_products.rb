class CreateDhlProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :dhl_products do |t|
      t.string      :code
      t.string      :name
      t.string      :content_code
      t.string      :doc_or_nondoc
      t.integer     :status
    end
  end
end
