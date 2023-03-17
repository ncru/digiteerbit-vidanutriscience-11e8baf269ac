class DhlPackageType < ApplicationRecord

  scope :active_dhl_package_types, -> {
    select("code, concat(code, ' - ', name) as name")
      .where("status=1")
      .order("code")
  }

  scope :for_datatables, -> {
    select("id, code, name, status")
  }
  
  validates :code,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
