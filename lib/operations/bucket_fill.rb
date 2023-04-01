require './lib/operations/base.rb'

module Operations
  class BucketFill < Operations::Base
    def initialize(canvas)
      super()
      @canvas = canvas
    end

    def call(params)
      extract(params) do |x, y, color|
        @canvas.bucket_fill(x, y, color)
      end
    end

    private

    def command_name
      'B'
    end

    def args_count
      3
    end

    def transform(params)
      [params[0].to_i - 1, params[1].to_i - 1, params[2]]
    end
  end
end
