class Division < ApplicationRecord

  has_many :products, dependent: :destroy
  has_many :sub_divisions, -> { order("name") }, dependent: :destroy

  scope :active_categories, -> {
    select("id,name")
      .where("status=1")
      .order("name")
  }

  scope :for_select_items, -> {
    select("id,name")
      .where("status=1")
      .order("name")
  }

  scope :for_datatables, -> {
    select("id,name,status")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
