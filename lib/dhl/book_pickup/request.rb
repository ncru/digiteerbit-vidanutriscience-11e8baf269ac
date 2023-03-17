require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class BookPickupRequest
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
        raise BookPickupOptionsError, ":#{req} is a required option"
      end
    end
    
    @pieces = []
  end

  def message_reference(request_id)
    @request_id = request_id
  end
  
  def consignee_details(consignee)
    @consignee = consignee
    @consignee_country_name = Country.find_by_code(consignee.shipping_country_code).name
    @total_weight = consignee.total_weight.to_f
    @total_pieces = consignee.order_items.count(1).to_i
    @dhl_params = consignee.dhl_response_value
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
    file = "#{Rails.root}/lib/dhl/xml_request/book_pickup.xml.erb"
    @to_xml = ERB.new(File.new(file).read, nil,'%<>-').result(binding)
  end
  
  def post
    puts servlet_url
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response
    puts response.body
    return BookPickupResponse.new(response.body)
  end

protected

  def servlet_url
    (ENV["PAYMENT_API_MODE"] == "live") ? URLS[:production] : URLS[:test]
  end

  def validate_pieces!
    pieces.each do |piece|
      klass_name = "BookPickupPiece"
      if piece.class.to_s != klass_name
        raise BookPickupPieceError, "entry in #pieces is not a #{klass_name} object!"
      end
    end
  end

  def validate_country_code!(country_code)
    unless country_code =~ /^[A-Z]{2}$/
      raise BookPickupCountryCodeError, 'country code must be upper-case, two letters (A-Z)'
    end
  end

end
