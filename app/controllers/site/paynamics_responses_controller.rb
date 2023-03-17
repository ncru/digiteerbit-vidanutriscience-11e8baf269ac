require 'sendgrid/mailer'

module Site
  class PaynamicsResponsesController < SiteController
    
    include SendGridMailer
    
    skip_before_action :verify_authenticity_token
    
    # This will receive the sale transaction post response from Paynamics Gateway.
    # POST /paynamics/notification/sales
    def paynamics_sales_response
      logger.tagged('Paynamics Responses') { 
        logger.info 'Receiving transaction response from paynamics.'
      }

      if params.present?
        response = Paynamics.response(params)
        unless response.valid?
          logger.tagged('Paynamics Responses', 'Response') { 
            logger.error "Invalid Paynamics Response Signature. Exiting."
            return
          }
        end
        
        create_transaction_data(response.data)
      else
        logger.tagged('Paynamics Responses') { 
          logger.error 'Received transaction response does not have any parameters.'
        }
      end

      head :no_content
    end
    
    private
    
    def create_transaction_data(response_data)
      logger.tagged('Paynamics Responses', response_data["request_id"]) { 
        logger.info 'Creating transaction data...'
      }
      
      order = Order.find_by(request_id: response_data["request_id"])

      if order.blank?
        logger.tagged('Paynamics Responses', response_data["request_id"]) { 
          logger.info 'Order with the given request id was not found. Exiting.'
        }
        
        return
      end

      # Check if the request_id being sent is already existing, if yes, just update the record.
      paynamics_response = PaynamicsResponse.find_by(request_id: response_data["request_id"])

      if paynamics_response.present?
        if paynamics_response.successful?
          # Prevent the status from being changed again if it's already successful.
          logger.tagged('Paynamics Responses', response_data["request_id"]) { 
            logger.info 'Paynamics Response Request ID found. It is already a successful transaction. Ignoring update.'
          }
          
          return
        else
          logger.tagged('Paynamics Responses', response_data["request_id"]) { 
            logger.info 'Paynamics Response Request ID found. Updating...'
          }
          
          paynamics_response.update(response_data)
        end
      else
        logger.tagged('Paynamics Responses', response_data["request_id"]) { 
          logger.info 'No Paynamics Response Request ID found. Saving...'
        }
        
        paynamics_response = PaynamicsResponse.create(response_data)
      end
      
      logger.tagged('Paynamics Responses', response_data["request_id"]) { 
        logger.info 'Paynamics Response has been successfully processed.'
        logger.info 'Processing order.'
      }
      
      # Deduct the stocks used.
      if paynamics_response.successful?
        logger.tagged('Paynamics Responses', response_data["request_id"]) { 
          logger.info 'Transaction is successful. Deducting stocks used.'
        }
        
        order.update(order_status_id: SystemSetting.find_by(name: 'FIRST_ORDER_STATUS_ID').value)

        # Deduct stocks, but only if not yet deducted.
        if !order.stocks_deducted?
          @inventory = Inventory.create(order_request_id: order.request_id)
          @inventory.update_product_stocks(order)
          
          # Update order as stocks_deducted already and complete.
          order.update(stocks_deducted: 1, complete: 1)
        else
          logger.tagged('Paynamics Responses', response_data["request_id"]) { 
            logger.info 'Stocks have already been deducted. This may be a previously pending transaction.'
          }
        end

        # Clear the current bag's contents.
        order.cart.destroy unless order.cart.blank?

      elsif paynamics_response.pending?
        # Deduct the stocks used and promo_code claimed.
        logger.tagged('Paynamics Responses', response_data["request_id"]) { 
          logger.info 'Transaction is pending. Deducting stocks used anyway.'
        }
        
        order.update(order_status_id: OrderStatus.find_by(name: 'Pending').id)

        # Deduct stocks, but only if not yet deducted.
        if !order.stocks_deducted?
          @inventory = Inventory.create(order_request_id: order.request_id)
          @inventory.update_product_stocks(order)
          
          # Update order as stocks_deducted already.
          order.update(stocks_deducted: 1)
        else
          logger.tagged('Paynamics Responses', response_data["request_id"]) { 
            logger.info 'Stocks have already been deducted.'
          }
        end

        # Clear the current bag's contents.
        order.cart.destroy unless order.cart.blank?
      else
        # Meaning failed transaction.
        # Return the stocks used and promo_code claimed.
        logger.tagged('Paynamics Responses', response_data["request_id"]) { 
          logger.info 'Transaction has failed.'
        }

        order.update(complete: 1)
      end

      logger.tagged('Paynamics Responses', response_data["request_id"]) { 
        logger.info 'Sending Order Email Confirmation.'
      }

      send_order_confirmation_email(order, order.amount)
    end
  end
end
