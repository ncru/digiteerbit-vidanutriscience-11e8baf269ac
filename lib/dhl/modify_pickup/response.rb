class ModifyPickupResponse
  
  attr_reader :raw_xml, :parsed_xml, :error

  def initialize(xml="")
    @raw_xml = xml
    begin
      @parsed_xml = MultiXml.parse(xml)
    rescue MultiXml::ParseError => e
      @error = e
      return self
    end

    if response_indicates_error?
      @error = case response_error_condition_code.to_s
      when "100"
        ModifyPickup::Upstream::ValidationFailureError.new(response_error_condition_data)
      else
        ModifyPickup::Upstream::UnknownError.new(response_error_condition_data)
      end
    elsif condition_indicates_error?
      @error = ModifyPickup::Upstream::ConditionError.new(condition_error_code, condition_error_message)
    end
  end

  def error?
    !!@error
  end
  
  def success?
    return (@parsed_xml["ModifyPUResponse"]["Note"]["ActionNote"] == "Success") ? true : false
  end
  
  def confirmation_number
    return @parsed_xml["ModifyPUResponse"]["ConfirmationNumber"]
  end

protected

  def response_indicates_error?
    @parsed_xml.keys.include?('ErrorResponse')
  end

  def response_error_status_condition
    @response_error_status_condition ||= @parsed_xml['ErrorResponse']['Response']['Status']['Condition']
  end

  def response_error_condition_code
    @response_error_condition_code ||= response_error_status_condition['ConditionCode']
  end

  def response_error_condition_data
    @response_error_condition_data ||= response_error_status_condition['ConditionData']
  end

  def condition_indicates_error?
    @parsed_xml.keys.include?('PickupErrorResponse')
  end

  def condition_error_code
    @parsed_xml["PickupErrorResponse"]["Response"]["Status"]["Condition"]["ConditionCode"]
  end

  def condition_error_message
    @parsed_xml["PickupErrorResponse"]["Response"]["Status"]["Condition"]["ConditionData"].strip
  end

end
