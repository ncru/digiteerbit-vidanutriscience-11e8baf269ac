require 'rubygems'
require 'httparty'
require 'erb'
require 'set'

class GetQuoteRequest
  attr_reader :site_id, :password, :from_country_code, :from_postal_code, :to_country_code, :to_postal_code, :duty
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
        raise GetQuoteOptionsError, ":#{req} is a required option"
      end
    end

    @special_services_list = Set.new
    @duty = false
    @pieces = []
  end

  def from(country_code, postal_code, city=nil)
    @from_postal_code = postal_code.to_s
    validate_country_code!(country_code)
    @from_country_code = country_code
    @from_city_name = city
  end

  def to(country_code, postal_code, city=nil)
    @to_postal_code = postal_code.to_s
    validate_country_code!(country_code)
    @to_country_code = country_code
    @to_city_name = city
  end

  def dutiable?
    !!@duty
  end

  def dutiable(value, currency_code="USD")
    @duty = {
      :declared_value => value.to_f,
      :declared_currency => currency_code.slice(0,3).upcase
    }
  end
  alias_method :dutiable!, :dutiable

  def not_dutiable!
    @duty = false
  end

  def payment_account_number(pac = nil)
    if pac.to_s.size > 0
      @payment_account_number = pac
    else
      @payment_account_number
    end
  end

  def dimensions_unit
    @dimensions_unit ||= GetQuote.dimensions_unit
  end

  def weight_unit
    @weight_unit ||= GetQuote.weight_unit
  end

  def metric_measurements!
    @weight_unit = GetQuote::WEIGHT_UNIT_CODES[:kilograms]
    @dimensions_unit = GetQuote::DIMENSIONS_UNIT_CODES[:centimeters]
  end

  def us_measurements!
    @weight_unit = GetQuote::WEIGHT_UNIT_CODES[:pounds]
    @dimensions_unit = GetQuote::DIMENSIONS_UNIT_CODES[:inches]
  end

  def to_xml
    validate!
    file = "#{Rails.root}/lib/dhl/xml_request/get_quote.xml.erb"
    @to_xml = ERB.new(File.new(file).read, nil,'%<>-').result(binding)
  end

  # ready times are only 8a-5p(17h)
  def ready_time(time=Time.now)
    if time.hour >= 17 || time.hour < 8
      time.strftime("PT08H00M")
    else
      time.strftime("PT%HH%MM")
    end
  end

  # ready dates are only mon-fri
  def ready_date(t=Time.now)
    date = Date.parse(t.to_s)
    if (date.cwday >= 6) || (date.cwday >= 5 && t.hour >= 17)
      date.send(:next_day, 8-date.cwday)
    else
      date
    end.strftime("%Y-%m-%d")
  end

  def post
    response = HTTParty.post(servlet_url,
      :body => to_xml,
      :headers => { 'Content-Type' => 'application/xml' }
    ).response

    return GetQuoteResponse.new(response.body)
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
    URLS[:production] # not working in test mode
  end

  def validate!
    raise GetQuoteFromNotSetError, "#from() is not set" unless (@from_country_code && @from_postal_code)
    raise GetQuoteToNotSetError, "#to() is not set" unless (@to_country_code && @to_postal_code)
    validate_pieces!
  end

  def validate_pieces!
    pieces.each do |piece|
      klass_name = "GetQuotePiece"
      if piece.class.to_s != klass_name
        raise GetQuotePieceError, "entry in #pieces is not a #{klass_name} object!"
      end
    end
  end

  def validate_country_code!(country_code)
    unless country_code =~ /^[A-Z]{2}$/
      raise GetQuoteCountryCodeError, 'country code must be upper-case, two letters (A-Z)'
    end
  end

end
