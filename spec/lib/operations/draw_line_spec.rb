require './spec/spec_helper'

RSpec.describe Operations::DrawLine do
  subject { Operations::DrawLine.new(canvas) }

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
        expect(subject.output).to receive(:puts).with('Command [L] accepts exactly 4 arguments')
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
    context 'line is invalid' do
      let(:params) { %w(1 1 2 3) }
      it 'prints error message and does nothing' do
        expect(subject.output).to receive(:puts).with('Line should be horizontal or vertical')
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(true)
      end
    end
    context 'line is valid' do
      let(:params) { %w(1 1 3 1) }
      it 'adds line to canvas' do
        expect(subject.output).not_to receive(:puts)
        subject.call(params)
        expect(Helpers.empty_canvas?(canvas)).to eq(false)
        expect(canvas.matrix[0].join).to eq('xxx ')
        expect(canvas.matrix[1].join).to eq('    ')
      end
    end
  end
end
