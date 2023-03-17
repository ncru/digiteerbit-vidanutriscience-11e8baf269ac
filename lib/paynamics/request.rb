module Paynamics
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options = {}, raw = false, unformatted = false, no_response_wrapper = no_response_wrapper(), signed=sign_requests)
      request(:get, path, options, raw, unformatted, no_response_wrapper, signed)
    end

    # Perform an HTTP POST request
    def post(path, options = {}, raw = false, unformatted = false, no_response_wrapper = no_response_wrapper(), signed=sign_requests)
      request(:post, path, options, raw, unformatted, no_response_wrapper, signed)
    end

    # Perform an HTTP PUT request
    def put(path, options = {}, raw = false, unformatted = false, no_response_wrapper = no_response_wrapper(), signed=sign_requests)
      request(:put, path, options, raw, unformatted, no_response_wrapper, signed)
    end

    # Perform an HTTP DELETE request
    def delete(path, options = {}, raw = false, unformatted = false, no_response_wrapper = no_response_wrapper(), signed=sign_requests)
      request(:delete, path, options, raw, unformatted, no_response_wrapper, signed)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, raw = false, unformatted = false, no_response_wrapper = false, signed=sign_requests)
      
      response = connection(raw).send(method) do |request|
        path = format_path(path) unless unformatted
        
        # Check if need to encode options.
        if signed == true
          options = encode64(options)
        end
        
        case method
        when :get, :delete
          request.url(URI.encode(path), options)
        when :post, :put
          request.path = URI.encode(path)
          request.body = options unless options.empty?
        end
      end
      
      return response if raw
      return response.body if no_response_wrapper
      return Response.create(response.body, {
        :limit => response.headers['x-ratelimit-limit'].to_i, 
        :remaining => response.headers['x-ratelimit-remaining'].to_i }
      )
    end

    def format_path(path)
      [path, format].compact.join('.')
    end
  end
end
