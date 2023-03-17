class Faq < ApplicationRecord

  scope :active_faqs, -> {
    select("question,answer")
      .where("status=1")
      .order("id")
  }

  scope :for_datatables, -> {
    select("id,title,created_at,updated_at,status")
  }

  validates :title, 
    presence: { message: "is required." }, 
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  validates :question, presence: { message: "is required." }
  validates :answer, presence: { message: "is required." }
end
