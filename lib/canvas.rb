class Canvas
  attr_reader :width, :height
  attr_reader :matrix
  attr_reader :output

  def initialize(width, height)
    # default output goes to stdout, possible to replace with anything else
    @output = $stdout

    if !valid_dimension?(width) || !valid_dimension?(height)
      raise ArgumentError, 'Only positive integers are allowed'
    end

    @width = width.to_i
    @height = height.to_i

    # initialize canvas matrix
    @matrix = (0..@height - 1).map do
      Array.new(@width, ' ')
    end
  end

  def draw
    @output.puts('-' * (@width + 2))
    (0..@height - 1).each do |row_index|
      @output.puts("-#{row_s(row_index)}-")
    end
    @output.puts('-' * (@width + 2))
  end

  def add_line(x1, y1, x2, y2)
    ensure_point_in_canvas! x1, y1
    ensure_point_in_canvas! x2, y2
    if x1 == x2 || y1 == y2
      fill_area([x1, x2].sort, [y1, y2].sort)
    else
      raise ArgumentError, 'Line should be horizontal or vertical'
    end
  end

  def add_rectangle(x1, y1, x2, y2)
    ensure_point_in_canvas! x1, y1
    ensure_point_in_canvas! x2, y2
    add_line(x1, y1, x1, y2)
    add_line(x1, y2, x2, y2)
    add_line(x2, y1, x2, y2)
    add_line(x1, y1, x2, y1)
  end

  def bucket_fill(x, y, color)
    ensure_point_in_canvas!(x, y)
    if color.nil? || color.to_s.length > 1
      raise ArgumentError, 'Color should be represented by 1 symbol'
    end
    fill(x, y, @matrix[y][x], color.to_s)
  end

  def valid_point?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end

  private

  def ensure_point_in_canvas!(x, y)
    raise ArgumentError, 'Point is outside canvas' unless valid_point?(x, y)
  end

  def fill_area(x_a, y_a)
    (x_a.first..x_a.last).each do |x|
      (y_a.first..y_a.last).each do |y|
        @matrix[y][x] = 'x'
      end
    end
  end

  def fill(x, y, target, new_color)
    return unless valid_point?(x, y)
    return if target == new_color
    return if @matrix[y][x] != target
    @matrix[y][x] = new_color
    fill(x + 1, y, target, new_color)
    fill(x - 1, y, target, new_color)
    fill(x, y + 1, target, new_color)
    fill(x, y - 1, target, new_color)
  end

  def row_s(row_index)
    @matrix[row_index].join
  end

  def valid_dimension?(val)
    val.to_i > 0
  end
end
