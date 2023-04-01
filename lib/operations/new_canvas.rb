require './lib/operations/base.rb'

module Operations
  class NewCanvas < Operations::Base
    def initialize
      super
      @rows, @columns = @input.winsize
    end

    def call(params)
      extract(params) do |width, height|
        validate(width, height) do
          return Canvas.new(width, height)
        end
      end
      nil
    end

    private

    def command_name
      'C'
    end

    def args_count
      2
    end

    def transform(params)
      params.map(&:to_i)
    end

    def validate(width, height)
      if width > 0 && width <= max_width && height > 0 && height <= max_height
        yield
      else
        @output.puts("Width should be within [1, #{max_width}], " \
                     "height should be within [1, #{max_height}]")
      end
    end

    def max_height
      @rows - 3
    end

    def max_width
      @columns - 2
    end

    def canvas_required?
      false
    end
  end
end
