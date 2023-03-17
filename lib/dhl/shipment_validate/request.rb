require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class ShipmentValidateRequest
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
        raise ShipmentValidateOptionsError, ":#{req} is a required option"
      end
    end
    @special_services_list = Set.new
    @duty = false
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
  end
  
  def shipper_details(shipper)
    @shipper = shipper
    @shipper_country_name = Country.find_by_code(shipper.country_code).name
  end
  
  def product_and_package(dhl_params)
    @product_code = dhl_params[:product_code]
    @package_type = dhl_params[:package_type]
  end
  
  def dutiable?
    !!@duty
  end
  
  def dutiable(value, currency_code="PHP")
    @duty = {
      :declared_value => value.to_f,
      :declared_currency => currency_code.slice(0,3).upcase
    }
  end
  
  alias_method :dutiable!, :dutiable

  def to_xml
    # validate_pieces!
    file = "#{Rails.root}/lib/dhl/xml_request/shipment_validate.xml.erb"
    @to_xml = ERB.new(File.new(file).read, nil,'%<>-').result(binding)
  end

  def post
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response
    puts response.body
    return ShipmentValidateResponse.new(response.body)
  end

  def special_services
    @special_services_list.to_a.sort
  end

  def add_special_service(special_service_type)
    return if special_service_type.to_s.size < 1
    @special_services_list << special_service_type
  end

  def remove_special_service(special_service_type)
    return if special_service_type.to_s.size < 1
    @special_services_list.delete_if{|x| x == special_service_type}
  end

protected

  def servlet_url
    (ENV["PAYMENT_API_MODE"] == "live") ? URLS[:production] : URLS[:test]
  end

  def validate_pieces!
    pieces.each do |piece|
      klass_name = "ShipmentValidatePiece"
      if piece.class.to_s != klass_name
        raise ShipmentValidatePieceError, "entry in #pieces is not a #{klass_name} object!"
      end
    end
  end

  def validate_country_code!(country_code)
    unless country_code =~ /^[A-Z]{2}$/
      raise ShipmentValidateCountryCodeError, 'country code must be upper-case, two letters (A-Z)'
    end
  end

end
