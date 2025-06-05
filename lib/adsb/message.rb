module ADSB
  class Message
    attr_reader :created_at
    
    # Create a new message.
    #
    # ==== Attributes
    # * +body+ - The body of the message as a hexadecimal string
    # * +created_at+ - The time at which the message was created
    #
    # ==== Examples
    #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098')
    #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098', Time.now)
    def initialize body, created_at = Time.now
      @body = body.hex.to_s(2)
      @created_at = created_at
      decoder = Kernel.const_get("ADSB::Messages::#{type.to_s.capitalize}")
      extend(decoder)
    end

    # Get the address of the sender.
    #
    # ==== Examples
    #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098')
    #   address = message.address
    def address
       '%02x' % @body[8..31].to_i(2)
    end

    def data
      @body[32..87]
    end

    def downlink_format
      @body[0..4].to_i(2)
    end

    def self.parse body
      downlink_format = body.hex.to_s(2)[0..4].to_i(2)
      if downlink_format == 17 or downlink_format == 18
        ADSB::Messages::Base.new(body)
      else
        ADSB::Messages::ModeSMessage.new(body)
      end
    end
  end
end
