class Career < ApplicationRecord

  scope :active_careers, -> {
    select("id")
      .where("status=1")
  }

  scope :career_openings, -> {
    select("id,position,description")
      .where("status=1")
      .order("id")
  }

  scope :for_datatables, -> {
    select("id,position,description,status")
  }

  validates :position, 
    presence: { message: "is required." }, 
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  validates :description, presence: { message: "is required." }
end
