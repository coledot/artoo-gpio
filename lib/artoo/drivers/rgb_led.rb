require 'artoo/drivers/driver'

module Artoo
  module Drivers
    class RgbLed < Driver
      # NOTE rgb led being used is a common-anode style led, meaning blah blah blah
      #      tl;dr values are reversed: 0/0/0 is full brightness; 255/255/255 is off
      LED_COLORS = {
        :off     => { red: 255, green: 255, blue: 255 },
        :blue    => { red: 255, green: 255, blue:   0 },
        :green   => { red: 255, green:   0, blue: 255 },
        :red     => { red:   0, green: 255, blue: 255 },
        :yellow  => { red:   0, green:   0, blue: 255 },
        :white   => { red:   0, green:   0, blue:   0 },
      }

      COMMANDS = [:color, :off].freeze

      def initialize(params = {})
        require 'pp'
        pp params
        missing_pins = [:red_pin, :green_pin, :blue_pin] - params[:additional_params].keys
        unless missing_pins.empty?
          raise "Must set at minimum: #{missing_pins.join ", "}"
        end

        @red_pin = params[:additional_params][:red_pin]
        @green_pin = params[:additional_params][:green_pin]
        @blue_pin = params[:additional_params][:blue_pin]
        @rgb_val = { red: 0, green: 0, blue: 0 }

        super
      end

      def color(new_color=nil)
        return @rgb_val unless new_color
        raise "#{new_color}? Never heard of it." unless LED_COLORS.keys.include? new_color
        @rgb_val = LED_COLORS[new_color]

        brightness(@red_pin, @rgb_val[:red])
        brightness(@green_pin, @rgb_val[:green])
        brightness(@blue_pin, @rgb_val[:blue])

        @rgb_val
      end

      def off
        color :off
      end

      private
      def brightness(pin, level=0)
        connection.pwm_write(pin, level)
      end
    end
  end
end
