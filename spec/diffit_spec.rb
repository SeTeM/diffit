require 'spec_helper'

describe Diffit do
  it 'has a version number' do
    expect(Diffit::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end

  describe "#configure" do
    before do
      MegaLotto.configure do |config|
        config.drawing_count = 10
      end
    end

    it "returns an array with 10 elements" do
      draw = MegaLotto::Drawing.new.draw

      expect(draw).to be_a(Array)
      expect(draw.size).to eq(10)
    end
  end
end
