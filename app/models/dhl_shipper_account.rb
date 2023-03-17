class DhlShipperAccount < ApplicationRecord

  scope :active_shipper_accounts, -> {
    select("id,account_number")
      .where("status=1")
      .order("account_number")
  }

  scope :for_datatables, -> {
    select("id, account_number, status")
  }
  
  validates :account_number, :shipper_id, :company,:address1,:city,:postal_code,
                            :country_code,:contact_person,:contact_no, 
                            presence: { message: "is required." }

  validates :account_number,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." }
end
