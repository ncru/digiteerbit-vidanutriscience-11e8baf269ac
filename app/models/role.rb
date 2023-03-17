class Role < ApplicationRecord

  scope :active_roles,->{
    select("id,name")
      .where("status=1")
      .where("id!=1")
      .order("name")
  }

  scope :for_datatables, -> {
    select("id,name,status")
      .where("id!=1")
      .order("name")
  }

  validates :name, 
    presence: { message: "is required." }, 
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
