# spec/models/content_block_spec.rb
require "rails_helper"

RSpec.describe ContentBlock, type: :model do
  describe "associations" do
    it { should belong_to(:document) }
  end

  describe "validations" do
    # Existing position validations
    it { should validate_presence_of(:position) }
    it { should validate_uniqueness_of(:position).scoped_to(:document_id) }

    # New html_id validations
    it { should allow_value(nil).for(:html_id) }
    it { should allow_value("").for(:html_id) } # Allow blank ID

    it "validates uniqueness of html_id scoped to document_id" do
      document = create(:document)
      create(:content_block, document: document, html_id: "unique-id")
      should validate_uniqueness_of(:html_id).scoped_to(:document_id).allow_blank(true)
    end

    it "validates html_id format" do
      should allow_value("my-id-123").for(:html_id)
      should allow_value("a").for(:html_id)
      should allow_value("id_with_underscore").for(:html_id)
      should_not allow_value("123-start-number").for(:html_id).with_message(/must start with a letter/)
      should_not allow_value("-start-hyphen").for(:html_id).with_message(/must start with a letter/)
      should_not allow_value("id with space").for(:html_id).with_message(/contain only letters/)
      should_not allow_value("id.with.dot").for(:html_id).with_message(/contain only letters/)
    end

    # Test data_attributes default value
    it "defaults data_attributes to an empty hash" do
      block = build(:content_block, data_attributes: nil)
      expect(block.data_attributes).to eq({})
    end

    it "allows valid data_attributes to be set" do
      block = build(:content_block, data_attributes: { "data-key" => "value", "aria-label" => "label" })
      expect(block.data_attributes).to eq({ "data-key" => "value", "aria-label" => "label" })
    end
  end
end
