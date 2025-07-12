# spec/models/video_embed_block_spec.rb
require "rails_helper"

RSpec.describe VideoEmbedBlock, type: :model do
  describe "associations" do
    it { should belong_to(:content_block) }
  end

  describe "validations" do
    it { should validate_presence_of(:embed_code) }
    # Add validation for embed_code format if needed
  end
end
