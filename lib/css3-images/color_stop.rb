require 'rmagick'

module Css3Images
  # Semi-public: Provides a convenient interface to enumerate over pairs of colors used as color stops in gradients.
  # It normalizes the color stop CSS3 value style of listing each distinct color in a sequence into a collection of pairs of colors to go from and to.
  #
  # They are factories for GradientFill instances.
  #
  # I would recommend using ColorStop.from
  class ColorStop
    attr_reader :from, :to, :height

    # Public: Sets the from, to and height values of a new ColorStop record.
    #
    # from   - The color to start the gradient at
    # to     - The color to end the gradient at
    # height - The distance the gradient should cover
    def initialize(from, to, height)
      @from, @to, @height = from, to, height
    end

    # Public: Factory for GradientFill instances.
    #
    # width - The width of the GradientFill
    #
    # Returns a Magick::GradientFill which goes from and to the ColorStop's colors.
    def to_gradient_fill(width)
      Magick::GradientFill.new(0, 0, width, 0, from, to)
    end

    class << self

      # Public: Normalizes lists of colors and heights into ColorStops
      #
      # stops - An Array of touples of colors and heights.
      #
      # Example
      #
      #   Css3Images::ColorStop([
      #     ["#000",0],
      #     ["#fff",17],
      #     ["#ccc",18]]
      #   => [Css3Image::ColorStop.new("#000","#fff",17),
      #       Css3Image::ColorStop.new("#fff","#ccc",18)]
      #
      # Return An Array of ColorStop instances
      def from(stops)
        color_stops = Array.new

        set = Array(stops)
        set.slice(1, set.length).each_with_index do |stop, i|
          color_stops << new(set[i].first, stop.first, stop.last)
        end

        color_stops
      end
    end
  end
end
