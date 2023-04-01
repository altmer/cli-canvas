require 'io/console'
require './lib/operations/new_canvas.rb'
require './lib/operations/draw_line.rb'
require './lib/operations/draw_rectangle.rb'
require './lib/operations/bucket_fill.rb'
require './lib/canvas.rb'

puts 'Welcome to RubyCanvas.'

canvas = nil

loop do
  canvas.draw if canvas
  print 'enter command: '

  input = gets.chomp
  command, *params = input.split(/\s+/)
  case command
  when 'Q'
    puts 'Bye'
    exit
  when 'C'
    canvas = Operations::NewCanvas.new.call(params)
  when 'L'
    Operations::DrawLine.new(canvas).call(params)
  when 'R'
    Operations::DrawRectangle.new(canvas).call(params)
  when 'B'
    Operations::BucketFill.new(canvas).call(params)
  else
    puts 'Unknown command'
  end
end
