require './spec/spec_helper'

RSpec.describe Operations::BucketFill do
  subject { Operations::BucketFill.new(canvas) }

  context 'no canvas' do
    let(:canvas) { nil }
    let(:params) { %w(1 1 w) }
    it 'prints error message and does nothing' do
      expect(subject.output).to receive(:puts).with('There is no canvas. Create one with command [C w h]')
      subject.call(params)
    end
  end
  context 'canvas is present' do
    let(:canvas) { Canvas.new(4, 4) }

    context 'wrong number of arguments' do
      let(:params) { %w(1 1) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Command [B] accepts exactly 3 arguments')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'point is outside' do
      let(:params) { %w(5 1 w) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Point is outside canvas')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'color is invalid' do
      let(:params) { %w(1 1 wer) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Color should be represented by 1 symbol')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'params are valid' do
      let(:params) { %w(1 1 w) }
      it 'adds line to canvas' do
        expect(subject.output).not_to receive(:puts)
        canvas.add_line(0, 1, 3, 1)
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(false)
        expect(canvas.matrix[0].join).to eq('wwww')
        expect(canvas.matrix[1].join).to eq('xxxx')
        expect(canvas.matrix[2].join).to eq('    ')
        expect(canvas.matrix[3].join).to eq('    ')
      end
    end
  end
end
