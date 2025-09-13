# == Schema Information
#
# Table name: aurelius_press_rich_text_blocks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
    it { should have_rich_text(:content) }
  end

  describe "validations" do
    it "has a valid, associated parent content block" do
      expect(subject.content_block).to be_present
      expect(subject.content_block).to be_valid
      expect(subject.content_block).to be_a(AureliusPress::ContentBlock::ContentBlock)
    end

    it "validates presence of content (rich text)" do
      subject.save!
      expect(subject).to be_valid
      expect(subject).to be_persisted
      expect(subject).to be_a(AureliusPress::ContentBlock::RichTextBlock)
      expect(subject.content).to be_present
      expect(subject.content.to_plain_text).to be_present
    end

    it "[FAILS] content does not exist" do
      expect(empty_rich_text_block).not_to be_valid
      expect(empty_rich_text_block).not_to be_persisted
      expect(empty_rich_text_block.content).to be_nil
      expect(empty_rich_text_block.errors[:content]).to be_present
      expect(empty_rich_text_block.errors[:content]).to include("can't be blank")
    end
  end
end
