class CreateCompanyDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :company_details do |t|
      t.text       :content
      t.attachment :photo
      t.timestamps
    end
  end
end
