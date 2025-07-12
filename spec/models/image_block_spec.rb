# spec/models/image_block_spec.rb
require "rails_helper"

RSpec.describe ImageBlock, type: :model do
  describe "associations" do
    it { should belong_to(:content_block) }
    it { should have_one_attached(:image) }
  end

  describe "validations" do
    it { should define_enum_for(:alignment).with_values([:left, :right, :center, :full_width]) }
    # Add validation for image presence if required
    # it 'validates presence of image' do
    #   block = build(:image_block, image: nil)
    #   expect(block).not_to be_valid
    #   expect(block.errors[:image]).to include("can't be blank")
    # end
  end
end
