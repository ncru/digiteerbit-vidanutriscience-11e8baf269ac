Dir[File.expand_path('../../builder/payload/*.rb', __FILE__)].each{ |f| require f }

module Paynamics
  class Client
    # Defines methods related to transactions.
    module Transactions
      
      # Builds the payload for a purchase transaction.
      # @param options [Hash] See Paynamics Paygate documentation Section 5.1 REQUEST PROCESS for the list of available options.
      # @return Base64 encoded version of the built XML object.
      # @see Paynamics Paygate documentation Section 5 RESPONSIVE PAYMENT TRANSACTION (RPF).
      def build_purchase_payload(options = {})
        signature = sign(purchase_signature_params(options))
        options   = options.merge(
          mid: merchant_id, 
          descriptor_note: descriptor_note, 
          certificate: merchant_key, 
          signature: signature, 
          trxtype: "sale"
        )
        
        builder = Paynamics::Builder::Payload::Sale.new(options)
        encode64(builder.xml)
      end
      
      private
      
      # Format the parameters for purchase transaction.
      def purchase_signature_params(options = {})
        [
          merchant_id,
          options[:request_id],
          options[:ip_address],
          options[:notification_url],
          options[:response_url],
          options[:fname],
          options[:lname],
          options[:mname],
          options[:address1],
          options[:address2],
          options[:city],
          options[:state],
          options[:country],
          options[:zip],
          options[:email],
          options[:phone],
          options[:client_ip],
          options[:amount],
          options[:currency],
          options[:secure3d],
          merchant_key
        ]
      end
    end
  end
end
