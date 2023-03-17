module GlobalPaymentsHelper
  def get_result_description(responseCode)
    case responseCode
      when "0" then "Transaction Successful"
      when "?" then "Transaction status is unknown"
      when "E" then "Referred"
      when "1" then "Transaction Declined"
      when "2" then "Bank Declined Transaction"
      when "3" then "No Reply from Bank"
      when "4" then "Expired Card"
      when "5" then "Insufficient funds"
      when "6" then "Error Communicating with Bank"
      when "7" then "Payment Server detected an error"
      when "8" then "Transaction Type Not Supported"
      when "9" then "Bank declined transaction (Do not contact Bank)"
      when "A" then "Transaction Aborted"
      when "B" then "Fraud Risk Blocked"
      when "C" then "Transaction Cancelled"
      when "D" then "Deferred transaction has been received and is awaiting processing"
      when "E" then "Transaction Declined - Refer to card issuer"
      when "F" then "3D Secure Authentication failed"
      when "I" then "Card Security Code verification failed"
      when "L" then "Shopping Transaction Locked (Please try the transaction again later)"
      when "M" then "Transaction Submitted (No response from acquirer)"
      when "N" then "Cardholder is not enrolled in Authentication scheme"
      when "P" then "Transaction has been received by the Payment Adaptor and is being processed"
      when "R" then "Transaction was not processed - Reached limit of retry attempts allowed"
      when "S" then "Duplicate SessionID (Amex Only)"
      when "T" then "Address Verification Failed"
      when "U" then "Card Security Code Failed"
      when "V" then "Address Verification and Card Security Code Failed"
      else "Unable to be determined"
    end
  end
  
  def get_avs_result_description(avs_result_code)
    if avs_result_code.present?
      case avs_result_code
        when "Unsupported" then "AVS not supported or there was no AVS data provided"
        when "X" then "Exact match - address and 9 digit ZIP/postal code"
        when "Y" then "Exact match - address and 5 digit ZIP/postal code"
        when "W" then "9 digit ZIP/postal code matched, Address not Matched"
			  when "S" then "Service not supported or address not verified (international transaction)"
        when "G" then "Issuer does not participate in AVS (international transaction)"
			  when "C" then "Street Address and Postal Code not verified for International Transaction due to incompatible formats."
        when "I" then "Visa Only. Address information not verified for international transaction."
			  when "A" then "Address match only"
        when "Z" then "5 digit ZIP/postal code matched, Address not Matched"
        when "R" then "Issuer system is unavailable"
        when "U" then "Address unavailable or not verified"
        when "E" then "Address and ZIP/postal code not provided"
			  when "B" then "Street Address match for international transaction. Postal Code not verified due to incompatible formats."
        when "N" then "Address and ZIP/postal code not matched"
        when "0" then "AVS not requested"
  			when "D" then "Street Address and postal code match for international transaction."
  			when "M" then "Street Address and postal code match for international transaction."
  			when "P" then "Postal Codes match for international transaction but street address not verified due to incompatible formats."
  			when "K" then "Card holder name only matches."
  			when "F" then "Street address and postal code match. Applies to U.K. only."
        else "Unable to be determined"
      end
    else
      "null response"
    end
  end
  
  def get_csc_result_description(csc_result_code)
    if csc_result_code.present?
      case csc_result_code
        when "Unsupported" then "CSC not supported or there was no CSC data provided"
        when "M" then "Exact code match"
        when "S" then "Merchant has indicated that CSC is not present on the card (MOTO situation)"
        when "P" then "Code not processed"
        when "U" then "Card issuer is not registered and/or certified"
        when "N" then "Code invalid or not matched"
        else "Unable to be determined"
      end
    else
      "null response"
    end
  end
end
