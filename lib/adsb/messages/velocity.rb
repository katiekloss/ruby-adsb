module ADSB
  module Messages
    class Velocity < Base

      # Get the reported heading.
      #
      # ==== Examples
      #   message = ADSB::Message.new('8D485020994409940838175B284F')
      #   heading = message.heading
      def heading
        heading = Math.atan2(@west_east_velocity, @south_north_velocity) * 360 / (2 * Math::PI)
        return heading < 0 ? heading + 360 : heading
      end

      def initialize body
        super(body)
        @west_east_velocity = signed_velocity(data[14..23].to_i(2), data[13].to_i(2))
        @south_north_velocity = signed_velocity(data[25..34].to_i(2), data[24].to_i(2))
      end

      # Get the reported velocity.
      #
      # ==== Examples
      #   message = ADSB::Message.new('8D485020994409940838175B284F')
      #   velocity = message.velocity
      def velocity
        return Math.sqrt(@west_east_velocity ** 2 + @south_north_velocity ** 2)
      end

      def signed_velocity velocity, velocity_sign
        return velocity_sign.eql?(0) ? velocity - 1 : -1 * (velocity - 1)
      end
    end
  end
end
