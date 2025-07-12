# spec/models/rich_text_block_spec.rb
require "rails_helper"

RSpec.describe RichTextBlock, type: :model do
  describe "associations" do
    it { should belong_to(:content_block) }
    it { should have_rich_text(:body) }
  end

  describe "validations" do
    # Assuming body content is required for a rich text block
    it "validates presence of body content" do
      block = build(:rich_text_block, body: nil)
      block.valid?
      expect(block.errors[:body]).to include("can't be blank")
    end
  end
end
