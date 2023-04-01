require './spec/spec_helper'

RSpec.describe Canvas do
  subject { Canvas.new(*dimensions) }

  describe '#initialize' do
    context 'when dimensions are zeroes' do
      let(:dimensions) { [0, 0] }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'Only positive integers are allowed')
      end
    end
    context 'when dimensions are positive' do
      let(:dimensions) { [4, 2] }
      let(:width) { dimensions.first }
      let(:height) { dimensions.last }

      it 'creates Canvas with data matrix' do
        expect(subject).to be_a Canvas
        expect(subject.matrix).not_to be_nil
        expect(subject.matrix.count).to eq(height)
        expect(subject.matrix[0].count).to eq(width)
        expect(Helpers.empty_canvas?(subject)).to eq(true)
      end
    end
  end

  describe '#add_line' do
    let(:dimensions) { [4, 4] }

    context 'line with point in negative space' do
      let(:line) { [-1, -1, 1, 1] }
      it 'raises ArgumentError' do
        expect { subject.add_line(*line) }.to raise_error(ArgumentError, 'Point is outside canvas')
        expect(Helpers.empty_canvas?(subject)).to eq(true)
      end
    end
    context 'line with point outside canvas' do
      let(:line) { [0, 0, 5, 2] }
      it 'raises ArgumentError' do
        expect { subject.add_line(*line) }.to raise_error(ArgumentError, 'Point is outside canvas')
        expect(Helpers.empty_canvas?(subject)).to eq(true)
      end
    end
    context 'valid horizontal line' do
      let(:line) { [0, 0, 2, 0] }
      it 'paints on canvas with x symbol' do
        subject.add_line(*line)
        expect(Helpers.empty_canvas?(subject)).to eq(false)
        (0..2).each do |x|
          expect(subject.matrix[0][x]).to eq('x')
        end
      end
    end
    context 'valid vertical line' do
      let(:line) { [1, 2, 1, 0] }
      it 'paints on canvas with x symbol' do
        subject.add_line(*line)
        expect(Helpers.empty_canvas?(subject)).to eq(false)
        (0..2).each do |y|
          expect(subject.matrix[y][1]).to eq('x')
        end
      end
    end
    context 'diagonal line' do
      let(:line) { [0, 0, 2, 1] }
      it 'raises ArgumentError' do
        expect { subject.add_line(*line) }.to raise_error(ArgumentError, 'Line should be horizontal or vertical')
        expect(Helpers.empty_canvas?(subject)).to eq(true)
      end
    end
  end

  describe '#add_rectangle' do
    let(:dimensions) { [4, 4] }

    context 'point outside canvas' do
      let(:rectangle) { [-1, -1, 1, 1] }
      it 'raises ArgumentError' do
        expect { subject.add_rectangle(*rectangle) }.to raise_error(ArgumentError, 'Point is outside canvas')
        expect(Helpers.empty_canvas?(subject)).to eq(true)
      end
    end
    context 'valid vertical line' do
      let(:rectangle) { [0, 0, 2, 2] }
      it 'paints on canvas with x symbol' do
        subject.add_rectangle(*rectangle)
        expect(Helpers.empty_canvas?(subject)).to eq(false)
        expect(subject.matrix[0].join).to eq('xxx ')
        expect(subject.matrix[1].join).to eq('x x ')
        expect(subject.matrix[2].join).to eq('xxx ')
        expect(subject.matrix[3].join).to eq('    ')
      end
    end
  end

  describe '#bucket_fill' do
    let(:dimensions) { [4, 4] }

    context 'color is nil' do
      let(:params) { [0, 0, nil] }
      it 'raises ArgumentError' do
        expect { subject.bucket_fill(*params) }.to raise_error(ArgumentError, 'Color should be represented by 1 symbol')
      end
    end
    context 'color is wrong' do
      let(:params) { [0, 0, 'fdf'] }
      it 'raises ArgumentError' do
        expect { subject.bucket_fill(*params) }.to raise_error(ArgumentError, 'Color should be represented by 1 symbol')
      end
    end
    context 'point is outside canvas' do
      let(:params) { [5, 0, 'w'] }
      it 'raises ArgumentError' do
        expect { subject.bucket_fill(*params) }.to raise_error(ArgumentError, 'Point is outside canvas')
      end
    end
    context 'canvas is blank' do
      let(:params) { [0, 0, 'w'] }
      it 'fills whole canvas with color' do
        subject.bucket_fill(*params)
        subject.matrix.each do |row|
          expect(row.join).to eq('wwww')
        end
      end
    end
    context 'canvas has closed areas' do
      let(:params) { [0, 0, 'w'] }
      it 'fills area with color' do
        subject.add_line(0, 1, 3, 1)
        subject.bucket_fill(*params)
        expect(subject.matrix[0].join).to eq('wwww')
        expect(subject.matrix[1].join).to eq('xxxx')
        expect(subject.matrix[2].join).to eq('    ')
        expect(subject.matrix[3].join).to eq('    ')
      end
    end
    context 'paint over line' do
      let(:params) { [0, 1, 'w'] }
      it 'fills area with color' do
        subject.add_line(0, 1, 3, 1)
        subject.bucket_fill(*params)
        expect(subject.matrix[0].join).to eq('    ')
        expect(subject.matrix[1].join).to eq('wwww')
        expect(subject.matrix[2].join).to eq('    ')
        expect(subject.matrix[3].join).to eq('    ')
      end
    end
  end

  describe '#draw' do
    let(:dimensions) { [4, 4] }

    context 'empty canvas' do
      it 'draws spaces' do
        expect(subject.output).to receive(:puts).with('------')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('------')
        subject.draw
      end
    end
    context 'added couple of lines' do
      it 'draws lines' do
        subject.add_line(1, 0, 1, 2)
        subject.add_line(0, 1, 2, 1)
        expect(subject.output).to receive(:puts).with('------')
        expect(subject.output).to receive(:puts).with('- x  -')
        expect(subject.output).to receive(:puts).with('-xxx -')
        expect(subject.output).to receive(:puts).with('- x  -')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('------')
        subject.draw
      end
    end
    context 'filed with custom color' do
      it 'draws lines' do
        subject.add_line(0, 1, 3, 1)
        subject.bucket_fill(2, 0, 'q')
        expect(subject.output).to receive(:puts).with('------')
        expect(subject.output).to receive(:puts).with('-qqqq-')
        expect(subject.output).to receive(:puts).with('-xxxx-')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('-    -')
        expect(subject.output).to receive(:puts).with('------')
        subject.draw
      end
    end
  end
end
