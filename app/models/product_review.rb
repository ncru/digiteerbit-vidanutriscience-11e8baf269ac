class ProductReview < ApplicationRecord

  belongs_to :customer
  belongs_to :product

  validates :review, presence: { message: "is required."}
  validates :rating, numericality: true

  scope :for_datatables, -> {
    select("p.id, p.photo, p.name as product_name, rc.rating as rating, rc.reviews_count")
      .from("products p LEFT JOIN (SELECT product_id,sum(rating) as rating, count(*) as reviews_count FROM product_reviews GROUP BY product_id) rc ON rc.product_id = p.id")
  }

  scope :for_review_datatables, -> (product_id) {
    select("pr.id, concat(c.first_name, ' ', c.last_name) as customer_name, pr.rating, pr.review, pr.created_at")
      .from("product_reviews pr JOIN customers c ON pr.customer_id = c.id")
      .where("pr.product_id = ?", product_id)
  }

end
