require 'date'

require "dhl/modify_pickup/errors"
require "dhl/modify_pickup/request"
require "dhl/modify_pickup/response"

class ModifyPickup

  def self.configure(&block)
    yield self if block_given?
  end

  def self.set_defaults
    @@site_id = nil
    @@password = nil
    @@test_mode = true
  end
end

ModifyPickup.set_defaults
