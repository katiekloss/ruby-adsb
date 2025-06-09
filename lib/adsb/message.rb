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
      if @body.length < 56
        @body = @body.rjust(56, "0")
      elsif @body.length < 112
        @body = @body.rjust(112, "0")
      end

      @created_at = created_at
      if downlink_format == 17 or downlink_format == 18
        extend(ADSB::Messages::Base)
        decoder = Kernel.const_get("ADSB::Messages::#{type.to_s.capitalize}")
        extend(decoder)
      end
    end

    def data
      @body[32..87]
    end

    def downlink_format
      @body[0..4].to_i(2)
    end
  end
end
