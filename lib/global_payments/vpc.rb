module VPCConnection
  class VPC_GATEWAY
    def self.setup_purchase(hash)
      @post_data = ""
      @hash_input = ""

      add_to_digital_order('vpc_AccessCode', (ENV["PAYMENT_API_MODE"] == "live") ? ENV['VPC_ACCESS_CODE'] : '1C9AFDEB')

      hash.each do |key, value|
        add_to_digital_order(key, value)
      end
      
      add_to_digital_order('vpc_SecureHash', hash_all_fields)
      add_to_digital_order('vpc_SecureHashType', 'SHA256')  
      
      @post_data = @post_data.sub!("&", "")
    end
    
    def self.add_to_digital_order(variable_name, variable_value)
      @post_data = @post_data.to_s + "&" + URI::escape(variable_name.to_s) + "=" + URI::escape(variable_value.to_s)
      @hash_input = @hash_input.to_s + "&" + variable_name.to_s + "=" + variable_value.to_s
    end
    
    def self.get_vpc_url
      return "https://migs.mastercard.com.au/vpcpay?" + @post_data
    end
    
    def self.hash_all_fields
      secure_hash_secret = ENV["PAYMENT_API_MODE"] == "live" ?  ENV["VPC_SECURE_HASH_SECRET"] : "8E7D9ED8DBD6FD94EEE5567073D31736"

      content = @hash_input.sub!("&", "")
      digest = OpenSSL::Digest.new('sha256')

      secure_hash = OpenSSL::HMAC.hexdigest(digest, [secure_hash_secret].pack('H*'), content).upcase
      return secure_hash
    end
  end
end