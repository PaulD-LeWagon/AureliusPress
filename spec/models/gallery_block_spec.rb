# spec/models/gallery_block_spec.rb
require "rails_helper"

RSpec.describe GalleryBlock, type: :model do
  describe "associations" do
    it { should belong_to(:content_block) }
    it { should have_many_attached(:images) }
  end

  describe "validations" do
    it { should define_enum_for(:layout_type).with_values([:grid, :carousel, :masonry]) }
    # Add validation for images presence if required (e.g., at least one image)
    # it 'validates presence of at least one image' do
    #   block = build(:gallery_block, images: [])
    #   expect(block).not_to be_valid
    #   expect(block.errors[:images]).to include("must have at least one image")
    # end
  end
end
