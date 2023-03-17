require 'date'

require "dhl/book_pickup/errors"
require "dhl/book_pickup/request"
require "dhl/book_pickup/response"
require "dhl/book_pickup/piece"

class BookPickup

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

BookPickup.set_defaults
