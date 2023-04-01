require './spec/spec_helper'

RSpec.describe Operations::NewCanvas do
  let(:screen_width) { 20 }
  let(:screen_height) { 10 }

  let(:dimensions_error_message) do
    "Width should be within [1, #{screen_width - 2}], " \
    "height should be within [1, #{screen_height - 3}]"
  end

  before do
    expect($stdin).to receive(:winsize).and_return([screen_height, screen_width])
  end
  subject { Operations::NewCanvas.new }

  describe '#call' do
    context 'wrong number of params' do
      let(:params) { %w(1 1 3) }
      it 'prints error message and returns nil' do
        expect(subject.output).to receive(:puts).with('Command [C] accepts exactly 2 arguments')
        expect(subject.call(params)).to be_nil
      end
    end
    context 'zero width' do
      let(:params) { %w(0 5) }
      it 'prints error message and returns nil' do
        expect(subject.output).to receive(:puts).with(dimensions_error_message)
        expect(subject.call(params)).to be_nil
      end
    end
    context 'width is too big' do
      let(:params) { %w(19 5) }
      it 'prints error message and returns nil' do
        expect(subject.output).to receive(:puts).with(dimensions_error_message)
        expect(subject.call(params)).to be_nil
      end
    end
    context 'zero height' do
      let(:params) { %w(5 0) }
      it 'prints error message and returns nil' do
        expect(subject.output).to receive(:puts).with(dimensions_error_message)
        expect(subject.call(params)).to be_nil
      end
    end
    context 'height is too big' do
      let(:params) { %w(5 8) }
      it 'prints error message and returns nil' do
        expect(subject.output).to receive(:puts).with(dimensions_error_message)
        expect(subject.call(params)).to be_nil
      end
    end
    context 'valid params' do
      let(:params) { %w(18 7) }
      it 'returns canvas with given dimensions' do
        expect(subject.output).not_to receive(:puts)
        canvas = subject.call(params)
        expect(canvas).not_to be_nil
        expect(canvas.width).to eq(params.first.to_i)
        expect(canvas.height).to eq(params.last.to_i)
      end
    end
  end
end
