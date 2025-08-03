# == Schema Information
#
# Table name: aurelius_press_gallery_blocks
#
#  id          :bigint           not null, primary key
#  layout_type :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe AureliusPress::ContentBlock::GalleryBlock, type: :model do

  # let!(:content_block) { build(:content_block, :as_a_gallery_block, :on_a_blog_post) }
  # subject { content_block.contentable } # This will be the GalleryBlock instance

  subject { build(:aurelius_press_content_block_gallery_block, :attached_to_a, document_type: :aurelius_press_document_blog_post) }
  # For the 'no images' test
  let(:gallery_without_images) {
    build(
      :aurelius_press_content_block_gallery_block,
      :with_out_images,
      :attached_to_a, document_type: :aurelius_press_document_blog_post,
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
    it { should have_many_attached(:images) }
  end

  describe "validations" do
    it { should define_enum_for(:layout_type).with_values([:grid, :carousel, :masonry]) }

    it "validates presence of at least one image" do
      expect(subject).to be_valid
      expect(subject.images).to be_attached
      expect(subject.images.count).to be > 0
      expect(subject.images.first).to be_a(ActiveStorage::Attachment)
    end

    it "does not validate with no images attached" do
      expect(gallery_without_images).not_to be_valid
      expect(gallery_without_images.images).not_to be_attached
      expect(gallery_without_images.images.count).to eq(0)
      expect(gallery_without_images.errors[:images]).to include("must have at least one image")
    end
  end
end
