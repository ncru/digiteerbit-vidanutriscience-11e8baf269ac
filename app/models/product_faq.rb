class ProductFaq < ApplicationRecord
  
  belongs_to :product

  scope :active_faqs, -> {
    select("question,answer")
      .where("status=1")
      .order("id")
  }

  validates :question, presence: { message: "is required."}
  validates :answer, presence: { message: "is required."}
end
