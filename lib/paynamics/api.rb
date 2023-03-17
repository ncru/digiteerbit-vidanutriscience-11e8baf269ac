require File.expand_path('../utils', __FILE__)
require File.expand_path('../connection', __FILE__)
require File.expand_path('../request', __FILE__)

module Paynamics
  # @private
  class API
    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new API.
    def initialize(options = {})
      options = Paynamics.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send(key)
      end
      conf
    end
    
    include Utils
    include Connection
    include Request
  end
end
