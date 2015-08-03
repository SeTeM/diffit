require 'spec_helper'

RSpec.describe Diffit do
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

  describe "tracks model changes" do
    context "on creating" do
      let!(:user) { User.create(login: 'vlad') }

      it "creates correct diff record" do
        expect(Diffit::Model.count).to eq(1)
        diff = Diffit::Model.last
        expect(diff.table_name).to eq(user.class.table_name)
        expect(diff.record_id).to eq(user.id)
        expect(diff.values.keys).to contain_exactly("login", "email")
        expect(diff.last_changed_at).not_to be_nil
      end
    end

    context "on updating" do
      let!(:user) { User.create(login: 'vlad') }

      xit "changes diff timestamps" do
        diff = Diffit::Model.last
        last_changed_at = diff.last_changed_at
        puts "1: #{last_changed_at.to_f}"
        user.update_attribute(:login, 'vlad')
        expect { user.update_attribute(:login, 'vlad') }
          .to change { diff.reload.last_changed_at }
        puts "2: #{diff.reload.last_changed_at.to_f}"
      end
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
