require './spec/spec_helper'

RSpec.describe Operations::DrawRectangle do
  subject { Operations::DrawRectangle.new(canvas) }

  context 'no canvas' do
    let(:canvas) { nil }
    let(:params) { %w(1 1 2 1) }
    it 'prints error message and does nothing' do
      expect(subject.output).to receive(:puts).with('There is no canvas. Create one with command [C w h]')
      subject.call(params)
    end
  end
  context 'canvas is present' do
    let(:canvas) { Canvas.new(4, 4) }

    context 'wrong number of arguments' do
      let(:params) { %w(1 1 3) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Command [R] accepts exactly 4 arguments')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'point is outside' do
      let(:params) { %w(1 1 5 1) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Point is outside canvas')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'rectangle is valid' do
      let(:params) { %w(1 1 3 3) }
      it 'adds rectangle to canvas' do
        expect(subject.output).not_to receive(:puts)
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(false)
        expect(canvas.matrix[0].join).to eq('xxx ')
        expect(canvas.matrix[1].join).to eq('x x ')
        expect(canvas.matrix[2].join).to eq('xxx ')
        expect(canvas.matrix[3].join).to eq('    ')
      end
    end
  end
end
