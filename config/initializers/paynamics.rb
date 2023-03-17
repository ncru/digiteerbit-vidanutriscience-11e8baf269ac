require File.expand_path('../../../lib/paynamics/paynamics', __FILE__)

if defined?(Paynamics)
  Paynamics.configure do |config|
    config.merchant_id     = ENV["PAYNAMICS_VIDA_MERCHANT_ID"]
    config.merchant_key    = ENV["PAYNAMICS_VIDA_CERTIFICATE"]
    config.endpoint        = ENV["PAYNAMICS_VIDA_PAYGATE_URL"]
    config.mtac_url        = ENV["PAYNAMICS_VIDA_MTAC_URL"]
    config.descriptor_note = "Vida 12345"
  end
end
