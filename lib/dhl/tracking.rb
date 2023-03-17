require "dhl/tracking/request"
require "dhl/tracking/response"

class Tracking

  def self.configure(&block)
    yield self if block_given?
  end

  def self.set_defaults
    @@site_id = nil
    @@password = nil
    @@test_mode = true
  end
end

Tracking.set_defaults
