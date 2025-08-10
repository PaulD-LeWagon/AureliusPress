# == Schema Information
#
# Table name: aurelius_press_image_blocks
#
#  id          :bigint           not null, primary key
#  caption     :string
#  alignment   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  link_text   :string
#  link_title  :string
#  link_class  :string
#  link_target :string
#  link_url    :string
#
# spec/models/image_block_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::ContentBlock::ImageBlock, type: :model do
  subject { build(:aurelius_press_content_block_image_block, :attached_to_a, document_type: :aurelius_press_document_journal_entry) }

  it "is valid and can be persisted" do
    expect(subject.persisted?).to be_falsey
    expect(subject).to be_valid
    expect(subject).to be_a(AureliusPress::ContentBlock::ImageBlock)
    expect(subject.content_block).to be_valid
    expect(subject.content_block).to be_a(AureliusPress::ContentBlock::ContentBlock)
    expect(subject.content_block.document).to be_valid
    expect(subject.content_block.document).to be_a(AureliusPress::Document::Document)
    expect(subject.content_block.document).to be_a(AureliusPress::Document::JournalEntry)
    subject.save!
    expect(subject).to be_persisted
    expect(subject.content_block).to be_persisted
    expect(subject.content_block.document).to be_persisted
  end

  describe "associations" do
    it { should have_one(:content_block) }
    it { should have_one_attached(:image) }
  end

  describe "validations" do
    it {
      should define_enum_for(:alignment).with_values([
               :left,
               :right,
               :center,
               :full_width,
               :float_left,
               :float_right,
             ])
    }

    it "validates presence of image" do
      expect(subject.image).to be_attached
      expect(subject.image).to be_a(ActiveStorage::Attached::One)
      expect(subject.image.blob).to be_present
      expect(subject.image.blob).to be_a(ActiveStorage::Blob)
      expect(subject.image.blob.filename).to eq("test_image.png")
      expect(subject.image.blob.content_type).to eq("image/png")
      expect(subject.caption).to be_present
      expect(subject.alignment).to be_present
      expect(AureliusPress::ContentBlock::ImageBlock.alignments.keys).to include(subject.alignment)
    end

    # Add validation for image presence if required
    it "validates presence of image with link attributes" do
      block = build(:aurelius_press_content_block_image_block, :with_link)
      expect(block).to be_valid
      expect(block.image).to be_attached
      expect(block.link_url).to eq("https://example.com")
      expect(block.link_title).to eq("Example")
      expect(block.link_class).to eq("example-class")
      expect(block.link_target).to eq("_blank")
      expect(block.link_text).to eq(block.caption || "Click here")
    end
  end
end
