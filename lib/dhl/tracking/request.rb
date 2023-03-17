require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class TrackingRequest
  attr_reader :site_id, :password, :duty
  attr_accessor :pieces

  URLS = {
    :production => 'https://xmlpi-ea.dhl.com/XMLShippingServlet',
    :test       => 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
  }

  def initialize(options = {})
    @site_id = ENV["DHL_API_SITE_ID"]
    @password = ENV["DHL_API_PASSWORD"]

    [ :site_id, :password ].each do |req|
      unless instance_variable_get("@#{req}").to_s.size > 0
        raise TrackingOptionsError, ":#{req} is a required option"
      end
    end
  end
  
  def message_reference(request_id)
    @request_id = request_id
  end
  
  def awb_number(awb_number)
    @awb_number = awb_number
  end
  
  def to_xml
    file = "#{Rails.root}/lib/dhl/xml_request/tracking.xml.erb"
    @to_xml = ERB.new(File.new(file).read, nil,'%<>-').result(binding)
  end
  
  def post
    puts servlet_url
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response
    puts response.body
    return TrackingResponse.new(response.body)
  end

protected

  def servlet_url
    (ENV["PAYMENT_API_MODE"] == "live") ? URLS[:production] : URLS[:test]
  end

end
