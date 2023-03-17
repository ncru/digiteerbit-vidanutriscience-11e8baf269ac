class Brand < ApplicationRecord

  include Slug

  scope :active_brands, -> {
    select("id,name,description,photo_url,slug")
      .where("status=1")
      .order("name")
  }

  scope :for_select_items, -> {
    select("id,name")
      .where("status=1")
      .order("name")
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
