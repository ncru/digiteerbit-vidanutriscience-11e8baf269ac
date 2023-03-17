class CancelPickupResponse
  
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
        CancelPickup::Upstream::ValidationFailureError.new(response_error_condition_data)
      else
        CancelPickup::Upstream::UnknownError.new(response_error_condition_data)
      end
    end
  end

  def error?
    !!@error
  end
  
  def success?
    return (@parsed_xml["CancelPUResponse"]["Note"]["ActionNote"] == "Success") ? true : false
  end
  
protected

  def response_indicates_error?
    @parsed_xml.keys.include?('PickupErrorResponse')
  end

  def response_error_status_condition
    @response_error_status_condition ||= @parsed_xml['PickupErrorResponse']['Response']['Status']['Condition']
  end
  
  def response_error_condition_code
    @response_error_condition_code ||= response_error_status_condition['ConditionCode']
  end

  def response_error_condition_data
    @response_error_condition_data ||= response_error_status_condition['ConditionData']
  end
end
