class TrackingResponse
  
  attr_reader :raw_xml, :parsed_xml

  def initialize(xml="")
    @raw_xml = xml
    # puts @raw_xml
    begin
      @parsed_xml = MultiXml.parse(xml)
    rescue MultiXml::ParseError => e
      @error = e
      return self
    end
  end
  
  def error?
    return ((@parsed_xml["TrackingResponse"]["AWBInfo"]["Status"]["ActionStatus"]).downcase != "success") ? true : false
  end

  def success?
    return ((@parsed_xml["TrackingResponse"]["AWBInfo"]["Status"]["ActionStatus"]).downcase == "success") ? true : false
  end
  
  def shipment_history
    return @parsed_xml["TrackingResponse"]["AWBInfo"]["ShipmentInfo"]["ShipmentEvent"]
  end
  
  def error
    @parsed_xml["TrackingResponse"]["AWBInfo"]["Status"]["ActionStatus"]
  end
end
