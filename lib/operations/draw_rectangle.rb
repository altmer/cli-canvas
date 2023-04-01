require './lib/operations/base.rb'

module Operations
  class DrawRectangle < Operations::Base
    def initialize(canvas)
      super()
      @canvas = canvas
    end

    def call(params)
      extract(params) do |x1, y1, x2, y2|
        @canvas.add_rectangle(x1, y1, x2, y2)
      end
    end

    private

    def command_name
      'R'
    end

    def args_count
      4
    end

    def transform(params)
      params.map { |num| num.to_i - 1 }
    end
  end
end
