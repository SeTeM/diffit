require 'spec_helper'

describe Diffit do
  it 'has a version number' do
    expect(Diffit::VERSION).not_to be nil
  end

  describe "#setup" do
    before do
      described_class.setup do |config|
        config.table_name = "diffits"
        config.serializer = :json
      end
    end

    it "#table_name" do
      expect(described_class.table_name).to eq("diffits")
    end

    it "#serializer_class" do
      expect(described_class.serializer_class).to eq(Diffit::Serializers::Json)
    end
  end
end
