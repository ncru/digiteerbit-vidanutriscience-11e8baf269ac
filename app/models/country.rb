class Country < ApplicationRecord

  scope :for_datatables, -> {
    select("id,name,code,status")
      .order("name")
  }
  
  scope :shipping_rate_new,->{
    select("name,code") 
      .from("countries")
      .where("code NOT IN (SELECT unnest(country_codes) as c_code FROM shipping_rates)")
  }
  
  scope :shipping_rate_edit,->(id){
    select("name,code") 
      .from("countries")
      .where("code NOT IN (SELECT unnest(country_codes) as c_code FROM shipping_rates where id!=?)", id)
  }
  
  scope :active_countries_from_shipping, ->{
    select("distinct c.code, c.name, s.id") 
      .from("(SELECT id, unnest(country_codes) as c_code FROM shipping_rates where status = 1) s JOIN countries c ON s.c_code = c.code")
      .order("c.name")
  }
  
  scope :active_countries,->{
    select("name,code") 
      .where("status = 1")
      .order("name")
  }
  
end
