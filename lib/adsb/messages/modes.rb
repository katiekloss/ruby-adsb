module ADSB
  module Messages
    class ModeSMessage
      def initialize body
        @body = body.hex.to_s(2)
      end
    end
  end
end