class CreateProductReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :product_reviews do |t|
      t.references  :customer, foreign_key: true, null: false
      t.references  :product, foreign_key: true, null: false
      t.integer     :rating, default: 0
      t.text        :review
      t.timestamps
    end
  end
end
