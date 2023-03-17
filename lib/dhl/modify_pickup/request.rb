require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class ModifyPickupRequest
  attr_reader :site_id, :password

  URLS = {
    :production => 'https://xmlpi-ea.dhl.com/XMLShippingServlet',
    :test       => 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
  }

  def initialize(options = {})
    @site_id = ENV["DHL_API_SITE_ID"]
    @password = ENV["DHL_API_PASSWORD"]

    [ :site_id, :password ].each do |req|
      unless instance_variable_get("@#{req}").to_s.size > 0
        raise ModifyPickupOptionsError, ":#{req} is a required option"
      end
    end
    @pieces = []
  end

  def message_reference(request_id)
    @request_id = request_id
  end
  
  def confirmation_number(confirmation_number)
    @confirmation_number = confirmation_number
  end
  
  def shipper_details(shipper)
    @shipper = shipper
    @shipper_country_name = Country.find_by_code(shipper.country_code).name
  end
  
  def ready_date(ready_date)
    @ready_date = ready_date
  end
  
  def package_location(location)
    @package_location = location
  end

  def to_xml
    # validate_pieces!
    file = "#{Rails.root}/lib/dhl/xml_request/modify_pickup.xml.erb"
    @to_xml = ERB.new(File.new(file).read, nil,'%<>-').result(binding)
  end
  
  def post
    puts servlet_url
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response
    puts response.body
    return ModifyPickupResponse.new(response.body)
  end

protected

  def servlet_url
    (ENV["PAYMENT_API_MODE"] == "live") ? URLS[:production] : URLS[:test]
  end

end
