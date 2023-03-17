class OrderStatus < ApplicationRecord
  
  has_many :order_status_updates, -> { order("id desc") }, dependent: :nullify
  has_many :orders, -> { order("id desc") }, dependent: :nullify

  scope :for_select_items, -> {
    select("id,name,dhl_service_id,courier_id,row_number() over(order by level, id) as level")
      .where("status=1")
      .order("level nulls first,id")
  }

  scope :for_datatables, -> {
    select("id,color_code,name,courier_id,status")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false,
      scope: [:courier_id, :dhl_service_id], 
      message: "<b>%{value}</b> has already been taken." }
      
  validates :color_code, presence: { message: "is required." }
end
