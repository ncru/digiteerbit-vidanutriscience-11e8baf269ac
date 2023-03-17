class CreateProductFaqs < ActiveRecord::Migration[5.0]
  def change
    create_table    :product_faqs do |t|
      t.string      :title
      t.text        :question, null: false
      t.text        :answer, null: false
      t.integer     :status
      t.references  :product, foreign_key: true, null: false
      t.timestamps
    end
  end
end
