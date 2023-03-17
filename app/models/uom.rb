class Uom < ApplicationRecord

  belongs_to :uom_label

  scope :active_uoms, -> {
    where("status=1")
  }

  scope :available_uoms, -> {
    select("id,name,unit")
      .where("status=1")
      .order("name")
  }

  scope :for_datatables, -> {
    select("uom.id,uom.name,uom.unit,uoml.name as label,uom.status")
      .from("uoms uom JOIN uom_labels uoml ON uom.uom_label_id = uoml.id")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
  validates :unit,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
