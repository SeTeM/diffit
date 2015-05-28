require 'spec_helper'

RSpec.describe Diffit do
  describe "VERSION" do
    subject { described_class::VERSION }

    it { is_expected.not_to be_nil }
  end

  describe "#setup" do
    before do
      described_class.setup do |config|
        config.table_name = "diffits"
        config.serializer = :json
        config.timestamp_format = ->(timestamp) { timestamp.to_s }
      end
    end

    it "#table_name" do
      expect(described_class.table_name).to eq("diffits")
    end

    it "#serializer_class" do
      expect(described_class.serializer_class).to eq(Diffit::Serializers::Json)
    end
  end

  describe ".diff_from" do
    let(:timestamp) { 1.day.ago }
    subject { User.diff_from(timestamp) }

    its([:timestamp]) { is_expected.to eq(timestamp.to_s) }

    context "with blank query" do
      its([:changes]) { is_expected.to be_blank }
    end

    context "with not blank query" do
      let!(:user) { User.create(login: 'vlad') }
      let!(:post) { Post.create }

      let(:expected) {[{
        "model" => "User",
        "record_id" => user.id,
        "values" => {
          "email" => nil,
          "login" => "vlad"
        }
      }]}

      its([:changes]) { is_expected.to eq(expected) }

      it "equals to model.diff_from" do
        expect(subject)
          .to eq(described_class.diff_from(timestamp, resources: [User]))
      end

      it "equals to scope.diff_from" do
        expect(subject).to eq(user.diff_from(timestamp))
      end
    end
  end

  describe ".diffit!" do
    class TestModel < ActiveRecord::Base
    end

    it "AR::Base has .diffit!" do
      expect(TestModel.respond_to?(:diffit!)).to be_truthy
    end

    it do
      expect { TestModel.diffit! }.to change {
        TestModel.respond_to?(:diff_from)
      }.from(false).to(true)
    end
  end
end
