class ShipmentValidateResponse
  
  attr_reader :raw_xml, :parsed_xml, :error
  attr_reader :label_image_base64, :awb_number, :confirmation

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
        ShipmentValidate::Upstream::ValidationFailureError.new(response_error_condition_data)
      else
        ShipmentValidate::Upstream::UnknownError.new(response_error_condition_data)
      end
    elsif condition_indicates_error?
      @error = ShipmentValidate::Upstream::ConditionError.new(condition_error_code, condition_error_message)
    end
  end

  def error?
    !!@error
  end
  
  def sucess?
    return (@parsed_xml["ShipmentValidateResponse"]["Note"]["ActionNote"] == "Success") ? true : false
  end

  def offered_services
    market_services.select do
      |m| m['TransInd'].to_s == "Y" || m['MrkSrvInd'].to_s == "Y"
    end.map do |m|
      ShipmentValidateMarketService.new(m)
    end.sort{|a,b| a.code <=> b.code }
  end

  def all_services
    market_services.map do |m|
      ShipmentValidateMarketService.new(m)
    end.sort{|a,b| a.code <=> b.code }
  end
  
  def label_image_base64
    @label_image_base64 = @parsed_xml["ShipmentValidateResponse"]["LabelImage"]["OutputImage"]
  end
  
  def awb_number
    @awb_number =  @parsed_xml["ShipmentValidateResponse"]["AirwayBillNumber"]
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
    @parsed_xml.keys.include?('ShipmentValidateErrorResponse')
  end

  def condition_error_code
    @parsed_xml["ShipmentValidateErrorResponse"]["Response"]["Status"]["Condition"]["ConditionCode"]
  end

  def condition_error_message
    @parsed_xml["ShipmentValidateErrorResponse"]["Response"]["Status"]["Condition"]["ConditionData"].strip
  end
  

  # def market_services
  #   @market_services ||= begin
  #     srv = @parsed_xml["DCTResponse"]["ShipmentValidateResponse"]["Srvs"]["Srv"]
  #     a = []
  #     if srv.is_a? Array
  #       srv.each{|aa| a << aa["MrkSrv"]}
  #     else
  #       a << srv["MrkSrv"]
  #     end
  #     a.flatten
  #   end
  #     # @parsed_xml["DCTResponse"]["ShipmentValidateResponse"]["Srvs"]["Srv"]["MrkSrv"]
  # end

end
