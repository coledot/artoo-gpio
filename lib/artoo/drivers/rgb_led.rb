require 'artoo/drivers/driver'

module Artoo
  module Drivers
    class RgbLed < Driver
      # NOTE rgb led being used is a common-anode style led, meaning blah blah blah
      #      tl;dr values are reversed: 0/0/0 is full brightness; 255/255/255 is off
      LED_COLORS = {
        :red    => { red:   0, green: 255, blue: 255 },
        :orange => { red:   0, green:  90, blue: 255 },
        :yellow => { red:   0, green:   0, blue: 255 },
        :green  => { red: 255, green:   0, blue: 255 },
        :blue   => { red: 255, green: 255, blue:   0 },
        :indigo => { red: 180, green: 255, blue: 125 },
        :violet => { red:  17, green: 125, blue:  17 },
        :white  => { red:   0, green:   0, blue:   0 },
        :off    => { red: 255, green: 255, blue: 255 },
      }

      COMMANDS = [:red, :orange, :yellow, :green, :blue, :indigo, :violet, :white, :off].freeze

      def initialize(params = {})
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

      def red
        color :red
      end

      def orange
        color :orange
      end

      def yellow
        color :yellow
      end

      def green
        color :green
      end

      def blue
        color :blue
      end

      def indigo
        color :indigo
      end

      def violet
        color :violet
      end

      def white
        color :white
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
