require 'builder'

module Paynamics
  module Builder
    module Payload
      # Responsible for bulding the payload for a Sale Transaction.
      class Sale
        attr_reader :xml
      
        # Convert the hash options to XML format
        # @param options [Hash]
        def initialize(options = {})
          xm = ::Builder::XmlMarkup.new
          xm.instruct!
          xm.Request {
            xm.orders {
              xm.items {
                options[:orders].each do |order|
                  xm.Items {
                    order.each_pair do |key, value|
                      xm.tag!(key, value)
                    end
                  }
                end
              }
            }
            
            # Add the other options except from the orders.
            options.except(:orders).each_pair do |key, value|
              xm.tag!(key, value)
            end
          }
          
          @xml = xm.target!
        end
      end
    end
  end
end
