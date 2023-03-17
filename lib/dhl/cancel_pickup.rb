require 'date'

require "dhl/cancel_pickup/errors"
require "dhl/cancel_pickup/request"
require "dhl/cancel_pickup/response"

class CancelPickup

  def self.configure(&block)
    yield self if block_given?
  end

  def self.set_defaults
    @@site_id = nil
    @@password = nil
    @@test_mode = true
  end
end

CancelPickup.set_defaults
