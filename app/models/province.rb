# frozen_string_literal: true

class Province < ApplicationRecord
  belongs_to :country
  belongs_to :customer_address
  has_many   :cities, -> { order("name") }, dependent: :destroy
  
  validates :code, presence: true
  validates :name, presence: true,
    uniqueness: { 
      case_sensitive: false, 
      message: "<b>%{value}</b> has already been taken." 
    }
  
  validates_format_of :code, :name, with: /\A[\w\d\s\-.ñ']*\z/
end
