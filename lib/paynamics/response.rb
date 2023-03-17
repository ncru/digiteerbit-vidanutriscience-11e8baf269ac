require File.expand_path('../utils', __FILE__)
require File.expand_path('../logger', __FILE__)

module Paynamics
  # Responsible for decoding the response received from the payment gateway.
  class Response
    include Utils
    
    attr_reader :response
    
    # Extract the parameters from the Paynamic Gateway response as a hash.
    # @param options [Hash]
    def initialize(options = {})
      @logger          = Paynamics::Logger.new.logger
      @paymentresponse = payment_response(options)
      @response        = xml_to_hash(decode64(@paymentresponse))
    end
    
    # Get the application data from Paynamics response.
    def application_data
      @response["ServiceResponseWPF"]["application"]
    end
    
    # Get the responseStatus data from Paynamics response.
    def status
      @response["ServiceResponseWPF"]["responseStatus"]
    end
    
    # @return Merged application data and responseStatus data.
    def data
      application_data.reverse_merge!(status)
    end
    
    # Check if the computed signature from the response is equal to the passed signature.
    def valid?
      signature == application_data["signature"]
    end
    
    private
    
    # Parse the payment response from the options hash.
    def payment_response(options = {})
      if options[:paymentresponse].present?
        # Get the encoded XML response and replace all spaces with '+'.
        options[:paymentresponse].dup.gsub! ' ', '+'
      else
        @logger.tagged('Paynamics', 'Response') { 
          @logger.info 'Received transaction response does not have any parameters named paymentresponse...'
          @logger.info 'Trying to handle unnamed parameter response...' 
        }
        
        first_param  = options.first[0].present? ? options.first[0].dup : ""
        second_param = options.first[1].present? ? options.first[1].dup : "="
        
        # Get the encoded XML response and replace all spaces with '+'.
        (first_param + second_param).gsub! ' ', '+'        
      end
    end
    
    def signature
      sign(response_signature_params)
    end
    
    def response_signature_params
      [
        application_data["merchantid"],
        application_data["request_id"],
        application_data["response_id"],
        status["response_code"],
        status["response_message"],
        status["response_advise"],
        application_data["timestamp"],
        application_data["rebill_id"],
        Paynamics.options[:merchant_key]
      ]
    end
  end
end
