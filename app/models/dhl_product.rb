class DhlProduct < ApplicationRecord

  scope :active_dhl_products, -> {
    select("code, concat(code, ' - ', name,' (',doc_or_nondoc,')') as name")
      .where("status=1")
      .order("code")
  }

  scope :for_datatables, -> {
    select("id, code, name, doc_or_nondoc, status")
  }
  
  validates :code,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
