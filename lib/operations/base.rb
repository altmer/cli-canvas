module Operations
  class Base
    attr_reader :input, :output, :canvas
    def initialize
      @input = $stdin
      @output = $stdout
      @canvas = nil
    end

    def extract(params)
      if canvas_required? && @canvas.nil?
        @output.puts 'There is no canvas. Create one with command [C w h]'
        return
      end
      if params.count == args_count
        begin
          yield transform(params)
        rescue ArgumentError => e
          @output.puts(e.message)
          return nil
        end
      else
        @output.puts("Command [#{command_name}] accepts exactly #{args_count} arguments")
      end
    end

    def canvas_required?
      true
    end
  end
end
