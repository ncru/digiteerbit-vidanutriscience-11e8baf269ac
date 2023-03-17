class ShippingRate < ApplicationRecord
  scope :for_datatables, -> {
    select("sr.id, sr.names, sr.status")
    .from("(SELECT s.id, array_to_string(array_agg(c.name), ', ') as names, s.status FROM (SELECT id, status, unnest(country_codes) as c_code FROM shipping_rates) s JOIN countries c ON s.c_code = c.code GROUP BY s.id, s.status) sr")
  }
  
  before_create :remove_empty_elements
  before_update :remove_empty_elements

  def get_countries
    codes = []
    self.country_codes.each do |code|
      codes << Country.find_by(code: code).name
    end
    return codes.join(', ')
  end
  
  def get_shipping_price(weight)
    total_weight = (weight*2).ceil.to_f / 2
    case total_weight
    when 0.5 then self.kg0p5
    when 1 then self.kg1p0
    when 1.5 then self.kg1p5
    when 2 then self.kg2p0
    when 2.5 then self.kg2p5
    when 3 then self.kg3p0
    when 3.5 then self.kg3p5
    when 4 then self.kg4p0
    when 4.5 then self.kg4p5
    when 5 then self.kg5p0
    when 5.5 then self.kg5p5
    when 6 then self.kg6p0
    when 6.5 then self.kg6p5
    when 7 then self.kg7p0
    when 7.5 then self.kg7p5
    when 8 then self.kg8p0
    when 8.5 then self.kg8p5
    when 9 then self.kg9p0
    when 9.5 then self.kg9p5
    when 10 then self.kg10p0
    when 10.5...99999 then self.kg10p0 + self.kg_add_on*(total_weight - 10)
    else 0         
    end  
  end
  
  def remove_empty_elements
    self.country_codes = self.country_codes.delete_if(&:blank?)
  end
  
  validates :country_codes, presence: { message: "is required." }
  validates :kg0p5,:kg1p0,:kg1p5,:kg2p0,:kg2p5,:kg3p0,:kg3p5,:kg4p0,:kg4p5,:kg5p0,:kg5p5,:kg6p0,:kg6p5,:kg7p0,:kg7p5,:kg8p0,:kg8p5,:kg9p0,:kg9p5,:kg10p0,:kg_add_on, presence: { message: "is required." }
end
