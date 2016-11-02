module ADSB
  module Messages
    module Position
      def altitude
        altitude = @body[40..51]
        resolution = altitude.slice!(7).eql?(0) ? 100 : 25
        altitude = altitude.to_i(2) * resolution - 1000
      end

      def latitude
        @body[54..70].to_i(2).to_f / 131072
      end

      def longitude
        @body[71..87].to_i(2).to_f / 131072
      end

      def odd?
        @body[53].to_i == 1
      end

      def even?
        @body[53].to_i == 0
      end

      def cpr_odd_even_frame_flag
        even? ? :even : :odd
      end

    end
  end
end
