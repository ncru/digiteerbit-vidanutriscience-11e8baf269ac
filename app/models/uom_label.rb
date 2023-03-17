class UomLabel < ApplicationRecord

  has_many :uoms, dependent: :nullify

  scope :active_uom_labels, -> {
    where("status=1")
  }

  scope :available_uom_labels, -> {
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
