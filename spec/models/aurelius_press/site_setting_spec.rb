require "rails_helper"

RSpec.describe AureliusPress::SiteSetting, type: :model do
  subject { AureliusPress::SiteSetting.new(key: "site_name", value: "AureliusPress", value_type: "string") }

  describe "validations" do
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:value_type) }
    it { should validate_uniqueness_of(:key) }
    it { should validate_inclusion_of(:value_type).in_array(%w[string boolean]) }
  end

  describe ".get" do
    it "returns the string value for a key" do
      AureliusPress::SiteSetting.create!(key: "site_name", value: "My Site", value_type: "string")
      expect(AureliusPress::SiteSetting.get("site_name")).to eq("My Site")
    end

    it "casts boolean true" do
      AureliusPress::SiteSetting.create!(key: "registration_open", value: "true", value_type: "boolean")
      expect(AureliusPress::SiteSetting.get("registration_open")).to be true
    end

    it "casts boolean false" do
      AureliusPress::SiteSetting.create!(key: "registration_open", value: "false", value_type: "boolean")
      expect(AureliusPress::SiteSetting.get("registration_open")).to be false
    end

    it "returns nil for an unknown key" do
      expect(AureliusPress::SiteSetting.get("nonexistent")).to be_nil
    end
  end

  describe ".set" do
    it "updates an existing setting's value" do
      AureliusPress::SiteSetting.create!(key: "site_name", value: "Old Name", value_type: "string")
      AureliusPress::SiteSetting.set("site_name", "New Name")
      expect(AureliusPress::SiteSetting.get("site_name")).to eq("New Name")
    end

    it "creates a new string setting if it does not exist" do
      expect {
        AureliusPress::SiteSetting.set("site_name", "Created")
      }.to change(AureliusPress::SiteSetting, :count).by(1)
    end
  end

  describe "#typed_value" do
    it "returns the raw string for string type" do
      setting = AureliusPress::SiteSetting.new(key: "site_name", value: "AureliusPress", value_type: "string")
      expect(setting.typed_value).to eq("AureliusPress")
    end

    it "returns true for boolean 'true'" do
      setting = AureliusPress::SiteSetting.new(key: "comments_enabled", value: "true", value_type: "boolean")
      expect(setting.typed_value).to be true
    end

    it "returns false for boolean 'false'" do
      setting = AureliusPress::SiteSetting.new(key: "comments_enabled", value: "false", value_type: "boolean")
      expect(setting.typed_value).to be false
    end
  end
end
