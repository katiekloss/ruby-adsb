module ADSB
  module Messages
    class ModeSMessage
      attr_reader :created_at

      def initialize body
        @body = body
        @created_at = Time.now
      end

      def downlink_format
        @body[0..4].to_i(2)
      end
    end
  end
end