module ADSB
  module Message
    
    # Create a new message.
    #
    # ==== Attributes
    # * +body+ - The body of the message as a hexadecimal string
    # * +created_at+ - The time at which the message was created
    #
    # ==== Examples
    #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098')
    #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098', Time.now)
    def self.new body
      parse(body)
    end

    def self.parse body
      body = body.hex.to_s(2)
      if body.length < 56
        body = body.rjust(56, "0")
      elsif body.length < 112
        body = body.rjust(112, "0")
      end

      downlink_format = body[0..4].to_i(2)
      if downlink_format == 17 or downlink_format == 18
        return case type_code(body)
        when 1, 2, 3, 4 then ADSB::Messages::Identification.new(body)
        when 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22 then ADSB::Messages::Position.new(body)
        when 19 then ADSB::Messages::Velocity.new(body)
        else ADSB::Messages::Base.new(body)
        end
      end
      
      ADSB::Messages::ModeSMessage.new(body)
    end

    def self.type_code body
      return body[32..36].to_i(2)
    end
  end
end
