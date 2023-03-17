require 'digest'
require 'base64'

module Paynamics
  module Utils
    
    # Calculate the SHA512 hash of the given arguments.
    # @param args [Array] The array of strings where the calculation will be based.
    # @return The calculated SHA512 hash of the given arguments.
    def sign(args)
      Digest::SHA2.new(512).hexdigest(args.reject(&:blank?).join)
    end
    
    # Base64 encodes the given argument.
    #
    # @param arg The object to be encoded.
    # @return The Base64-encoded version of the given argument.
    def encode64(arg)
      Base64.encode64(arg)
    end
    
    # Base64 decode the given argument.
    #
    # @param arg The object to be decoded.
    # @return The decoded version of the given argument.
    def decode64(arg)
      Base64.decode64(arg)
    end
    
    # Convert XML to Hash.
    # @param arg [XML] The XML data to convert.
    # @return Hash equivalent of the XML data.
    def xml_to_hash(arg)
      Hash.from_xml(arg)
    end
  end
end
