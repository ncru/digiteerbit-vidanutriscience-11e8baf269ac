require 'date'

require "dhl/get_quote/helper"
require "dhl/get_quote/errors"
require "dhl/get_quote/request"
require "dhl/get_quote/response"
require "dhl/get_quote/piece"
require "dhl/get_quote/market_service"

class GetQuote

  DIMENSIONS_UNIT_CODES = { :centimeters => "CM", :inches => "IN" }
  WEIGHT_UNIT_CODES = { :kilograms => "KG", :pounds => "LB" }

  def self.configure(&block)
    yield self if block_given?
  end

  def self.metric_measurements!
    @@weight_unit = WEIGHT_UNIT_CODES[:kilograms]
    @@dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
  end

  def self.us_measurements!
    @@weight_unit = WEIGHT_UNIT_CODES[:pounds]
    @@dimensions_unit = DIMENSIONS_UNIT_CODES[:inches]
  end

  def self.weight_unit
    @@weight_unit
  end

  def self.dimensions_unit
    @@dimensions_unit
  end

  def self.set_defaults
    @@site_id = nil
    @@password = nil
    @@weight_unit = WEIGHT_UNIT_CODES[:kilograms]
    @@dimensions_unit = DIMENSIONS_UNIT_CODES[:centimeters]
    @@dutiable = false
    @@test_mode = false
  end
end

GetQuote.set_defaults
