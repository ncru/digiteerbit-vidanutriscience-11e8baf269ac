module Paynamics
  # Wrapper for the Paynamics API
  #
  # @note All methods have been separated into modules
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{ |f| require f }
    
    include Paynamics::Client::Transactions
  end
end
