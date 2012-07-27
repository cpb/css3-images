require 'css3-images/color_stop'
require 'rmagick'

module Css3Images
  # Public: Provides a Ruby Interface to the CSS3 linear-gradient image value.
  #
  # The intention for this is to provide a way to initialize an image factory with
  # a normalized set of arguments which can produce linear gradient images.
  #
  # Class methods will provide parsers which will normalize linear-gradient
  # strings into the argument signature for LinearGradient.new.
  #
  # LinearGradient delegates to a Magick::Image instance for writing.
  #
  # Currently limited to:
  #   - top to bottom gradients only
  class LinearGradient
    attr_reader :width, :color_stops

    # Public: Create a linear-gradient factory.
    #
    # attributes - a hash used to define the linear-gradient:
    #              :width       - The width of the image
    #              :color_stops - An array of color and height specifications
    #
    # Examples
    #
    #   grey_to_white = Css3Images::LinearGradient.new width: 1,
    #                                                  color_stops: [
    #                                                    ["rgb(242,242,242)", 0],
    #                                                    ["rgb(255,255,255)", 17]]
    #
    #   grey_to_white.write("example.png")
    #
    # Returns a linear gradient object
    def initialize(attributes)
      @width = attributes.fetch(:width)
      @color_stops = ColorStop.from(Array(attributes.fetch(:color_stops)))
    end

    # Public: Returns a Magick::Image depicting the defined LinearGradient.
    def image
      @image_memo ||= begin
        steps = Magick::ImageList.new

        color_stops.inject(steps) do |memo, stop|
          memo << Magick::Image.new(width, stop.height, stop.to_gradient_fill(width))
        end

        combined = steps.append(true)
        #color = Magick::Image.new(combined.columns, combined.rows) do
          #self.background_color = "#fff"
        #end

        #combined.composite(color, Magick::CenterGravity, Magick::ColorizeCompositeOp)
      end
    end

    # Public: Creates and writes the image to the path.
    #
    # path - path to write the image to
    #
    # Returns the generated image
    def write(path)
      image.write(path)
      image
    end
  end
end
