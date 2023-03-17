class Advertisement < ApplicationRecord

  scope :active_advertisements, -> {
    select("name,photo_url")
      .where("status=1")
      .order("RANDOM()")
      .limit(2)
  }

  scope :for_datatables, -> {
    select("id,photo_url,name,status")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  validates :photo_url, presence: { message: "is required." }
end
