require 'faraday_middleware'
Dir[File.expand_path('../faraday/*.rb', __FILE__)].each{|f| require f}

module Paynamics
  # @private
  module Connection
    private

    def connection(raw=false)
      options = {
        :headers => {'Accept' => "*/*; charset=utf-8"},
        :url => endpoint,
      }.merge(connection_options)
      
      Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify unless raw
        unless raw
          case format.to_s.downcase
          when 'json' then connection.use Faraday::Response::ParseJson
          when 'xml' then connection.use Faraday::Response::ParseXml
          end
        end
        connection.use FaradayMiddleware::RaiseHttpException
        connection.adapter(adapter)
      end
    end
  end
end
