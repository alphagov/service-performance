module SparklineHelper
  def draw_sparkline(monthly_data)
    spark = Sparkline::Spark.new(monthly_data, height: 20, width: 70)
    spark.svg(color: "#005EA5", stroke: 2).html_safe
  end

  module Sparkline
    class Spark
      # Creates a new sparkline generator for a single list
      # of numbers
      #
      # Params
      # + num_list:: A list of floats to be rendered
      # + height:: The height (in pixels) of the output SVG
      # + width:: The width (in pixels) of the output SVG
      def initialize(num_list, height: 100, width: 200.0)
        @height = height.to_f
        @width = width.to_f

        @xpoints = (0..(@width - 1)).step(@width / num_list.length).to_a.map { |x| x.round(2) }
        @target_delta = height.to_f

        # Get the minimum and maximum values from our input
        # data so that we can scale the numbers to fix the
        # height of our SVG
        @min, @max = num_list.minmax
        @values = scale(num_list)
        @titles = num_list.map { |n|
          ::ApplicationController.helpers.number_with_delimiter(n, delimiter: ',')
        }
      end

      # Output the sparkline as an SVG
      #
      # Params
      # + color:: The CSS color of the lines
      # + stroke:: The thickness of the lines
      def svg(color: "black", stroke: 5)
        <<-eos
    <svg width="#{@width.to_i}" height="#{@height.to_i}">
      <title>#{@titles}</title>
      <polyline points="#{point_string}" stroke="#{color}" stroke-width="#{stroke}" fill="none" stroke-linecap="square"/>
    </svg>
        eos
      end

    private

      def point_string
        # We have to invert the Y index because origin is top left (not bottom right)
        @xpoints.zip(@values).map { |x, y|
          y = 0 if y.nan?

          yval = [@height - y - 2.0, 2.0].max.round(2)
          "#{x},#{yval}"
        }.join(' ')
      end

      def scale(numbers)
        numbers.map(&:to_f)
        source_delta = @max - @min
        numbers.map { |i|
          ((@target_delta * (i - @min)) / source_delta)
        }
      end
    end
  end
end
