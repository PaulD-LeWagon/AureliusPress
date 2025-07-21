# spec/models/content_block_spec.rb
require "rails_helper"

RSpec.describe ContentBlock, type: :model do
  subject { build(:content_block, :as_rich_text_block, :on_a_blog_post) }

  describe "associations" do
    it { should belong_to(:document) }
    it { should have_many(:likes).dependent(:destroy).inverse_of(:likeable) }
    it { should have_many(:notes).dependent(:destroy).inverse_of(:notable) }
  end

  describe "validations" do
    # Existing position validations
    it { should validate_presence_of(:position) }
    it { should validate_uniqueness_of(:position).scoped_to(:document_id) }

    # New html_id validations
    it { should allow_value(nil).for(:html_id) }
    it { should allow_value("").for(:html_id) } # Allow blank ID

    it "validates uniqueness of html_id scoped to document_id" do
      should validate_uniqueness_of(:html_id).scoped_to(:document_id).allow_blank
    end

    it "validates html_id format" do
      should allow_value("my-id-123").for(:html_id)
      should allow_value("a").for(:html_id)
      should allow_value("id_with_underscore").for(:html_id)
      should_not allow_value("123-start-number").for(:html_id)
      should_not allow_value("-start-hyphen").for(:html_id)
      should_not allow_value("id with space").for(:html_id)
      should_not allow_value("id.with.dot").for(:html_id)
    end

    # Test data_attributes default value
    it "defaults data_attributes to an empty hash" do
      expect(subject.data_attributes).to eq({})
    end

    it "allows valid data_attributes to be set" do
      # This test name is a bit misleading, as data_attributes is flexible
      # but we can still check that it accepts a hash
      subject.data_attributes = { "data-key" => "value", "aria-label" => "label" }
      expect(subject.data_attributes).to eq({ "data-key" => "value", "aria-label" => "label" })
    end
  end
end
