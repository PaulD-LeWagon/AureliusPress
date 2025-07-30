# spec/models/rich_text_block_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::ContentBlock::RichTextBlock, type: :model do
  subject { build(:aurelius_press_content_block_rich_text_block, :attached_to_a, document_type: :aurelius_press_document_page) }
  # For the 'no images' test
  let(:empty_rich_text_block) {
    build(
      :aurelius_press_content_block_rich_text_block,
      :without_content,
      :attached_to_a, document_type: :aurelius_press_document_page,
    )
  }

  it "is valid and can be persisted" do
    expect(subject.persisted?).to be_falsey
    expect(subject).to be_valid
    expect(subject.content_block).to be_valid
    expect(subject.content_block.document).to be_valid
    subject.save!
    expect(subject).to be_persisted
    expect(subject.content_block).to be_persisted
    expect(subject.content_block.document).to be_persisted
  end

  describe "associations" do
    it { should have_one(:content_block) }
    it { should have_rich_text(:body) }
  end

  describe "validations" do
    it "has a valid, associated parent content block" do
      expect(subject.content_block).to be_present
      expect(subject.content_block).to be_valid
      expect(subject.content_block).to be_a(AureliusPress::ContentBlock::ContentBlock)
    end

    it "validates presence of content body (rich text)" do
      subject.save!
      expect(subject).to be_valid
      expect(subject).to be_persisted
      expect(subject).to be_a(AureliusPress::ContentBlock::RichTextBlock)
      expect(subject.body).to be_present
      expect(subject.body.to_plain_text).to be_present
    end

    it "[FAILS] body content does not exist" do
      expect(empty_rich_text_block).not_to be_valid
      expect(empty_rich_text_block).not_to be_persisted
      expect(empty_rich_text_block.body).to be_nil
      expect(empty_rich_text_block.errors[:body]).to be_present
      expect(empty_rich_text_block.errors[:body]).to include("can't be blank")
    end
  end
end
