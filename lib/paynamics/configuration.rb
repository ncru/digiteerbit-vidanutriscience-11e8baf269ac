require 'faraday'

module Paynamics
  # Defines constants and methods related to configuration
  module Configuration
    
    # An array of valid keys in the options hash when configuring a {Paynamics::API}
    VALID_OPTIONS_KEYS = [
      :merchant_id,
      :merchant_key,
      :mtac_url,
      :endpoint,
      :descriptor_note,
      :connection_options,
      :format,
      :no_response_wrapper,
      :adapter,
      :sign_requests
    ].freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter
    
    # By default, don't set a merchant ID
    DEFAULT_MERCHANT_ID = nil

    # By default, don't set an application ID
    DEFAULT_MERCHANT_KEY = nil

    # By default, don't set a mtac url
    DEFAULT_MTAC_URL = nil
    
    # By default, don't set a descriptor note
    DEFAULT_DESCRIPTOR_NOTE = nil

    # By default, set the endpoint to the test url
    DEFAULT_ENDPOINT = 'https://testpti.payserv.net/'.freeze
    
    # By default, don't set any connection options
    DEFAULT_CONNECTION_OPTIONS = {}
    
    # By default, don't wrap responses with meta data (i.e. pagination)
    DEFAULT_NO_RESPONSE_WRAPPER = false

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note XML is the only available format at this time
    DEFAULT_FORMAT = :xml
    
    # By default, requests are not signed
    DEFAULT_SIGN_REQUESTS = true

    # An array of valid request/response formats
    VALID_FORMATS = [
      :xml
    ].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.merchant_id         = DEFAULT_MERCHANT_ID
      self.merchant_key        = DEFAULT_MERCHANT_KEY
      self.mtac_url            = DEFAULT_MTAC_URL
      self.endpoint            = DEFAULT_ENDPOINT
      self.descriptor_note     = DEFAULT_DESCRIPTOR_NOTE
      self.connection_options  = DEFAULT_CONNECTION_OPTIONS
      self.format              = DEFAULT_FORMAT
      self.no_response_wrapper = DEFAULT_NO_RESPONSE_WRAPPER
      self.adapter             = DEFAULT_ADAPTER
      self.sign_requests       = DEFAULT_SIGN_REQUESTS
    end
  end
end
