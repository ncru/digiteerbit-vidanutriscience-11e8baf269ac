require File.expand_path('../error', __FILE__)
require File.expand_path('../configuration', __FILE__)
require File.expand_path('../api', __FILE__)
require File.expand_path('../client', __FILE__)
require File.expand_path('../response', __FILE__)

module Paynamics
  extend Configuration
  
  # Alias for Paynamics::Client.new
  #
  # @return [Paynamics::Client]
  def self.client(options = {})
    Paynamics::Client.new(options)
  end
  
  # Alias for Paynamics::Response.new
  #
  # @return [Paynamics::Response]
  def self.response(options = {})
    Paynamics::Response.new(options)
  end

  # Delegate to Paynamics::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Paynamics::Client
  def self.respond_to?(method, include_all=false)
    return client.respond_to?(method, include_all) || super
  end
end
