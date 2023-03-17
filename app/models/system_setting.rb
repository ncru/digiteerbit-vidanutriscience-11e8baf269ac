class SystemSetting < ApplicationRecord

  scope :for_datatables, -> {
    select("id,name,value,status")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
