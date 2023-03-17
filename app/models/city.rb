# frozen_string_literal: true

class City < ApplicationRecord
  
  belongs_to :province
  belongs_to :customer_address
  validates :name, presence: true
  
  validates_format_of :name, with: /\A[\w\d\s\-.ñ']*\z/
end
