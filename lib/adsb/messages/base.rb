require 'adsb/messages/modes'

module ADSB
  module Messages
    class Base < ModeSMessage
      # Get type of message.
      #
      # ==== Examples
      #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098')
      #   type = message.type
      def type
        case type_code
          when 1, 2, 3, 4 then :identification
          when 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22 then :position
          when 19 then :velocity
        end
      end

      def data
        @body[32..87]
      end

      def type_code
        @body[32..36].to_i(2)
      end

      # Get the address of the sender.
      #
      # ==== Examples
      #   message = ADSB::Message.new('8D4840D6202CC371C32CE0576098')
      #   address = message.address
      def address
        '%02x' % @body[8..31].to_i(2)
      end
    end
  end
end
