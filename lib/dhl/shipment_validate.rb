require 'date'

require "dhl/shipment_validate/errors"
require "dhl/shipment_validate/request"
require "dhl/shipment_validate/response"
require "dhl/shipment_validate/piece"

class ShipmentValidate

  DIMENSIONS_UNIT_CODES = { :centimeters => "CM", :inches => "IN" }
  WEIGHT_UNIT_CODES = { :kilograms => "KG", :pounds => "LB" }

  def self.configure(&block)
    yield self if block_given?
  end

  def self.set_defaults
    @@site_id = nil
    @@password = nil
    @@weight_unit = WEIGHT_UNIT_CODES[:kilograms]
    @@dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
    @@dutiable = false
    @@test_mode = true
  end
end

ShipmentValidate.set_defaults
