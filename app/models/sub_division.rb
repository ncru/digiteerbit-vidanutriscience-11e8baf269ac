class SubDivision < ApplicationRecord

  belongs_to :division

  scope :active_sub_categories, ->(division_id) {
    select("id,name")
      .where("status=1")
      .where("division_id = ?", division_id)
  }

  scope :for_select_items, ->(id) {
    select("id,name")
      .where("status=1")
      .where("division_id = ?", id)
  }

  scope :for_datatables, -> {
    select("s.id as sub_category_id,s.name as sub_category_name,s.division_id,d.name as category_name,s.status")
    .from("sub_divisions s JOIN divisions d ON s.division_id = d.id")
  }

  validates :name,
    presence: { message: "is required." },
    uniqueness: { 
      case_sensitive: false, 
      scope: :division_id, 
      message: "<b>%{value}</b> has already been defined in the same category." }
end
