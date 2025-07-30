# spec/models/video_embed_block_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::ContentBlock::VideoEmbedBlock, type: :model do
  # Use subject to provide a default valid instance for many tests
  subject { build(:aurelius_press_content_block_video_embed_block, :with_nil_fields, :attached_to_a, document_type: :aurelius_press_document_blog_post) }

  it "is valid and can be persisted" do
    expect(subject.persisted?).to be_falsey
    subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID456"
    expect(subject).to be_valid
    expect(subject.content_block).to be_valid
    expect(subject.content_block.document).to be_valid
    subject.save!
    expect(subject).to be_persisted
    expect(subject.content_block).to be_persisted
    expect(subject.content_block.document).to be_persisted
    subject.video_url = nil
  end

  context "associations" do
    it { should have_one(:content_block) }
  end

  context "validations" do
    it { should validate_presence_of(:content_block) }
    it { should validate_presence_of(:video_url) }
    it { should validate_presence_of(:embed_code) } # This will be set by callback

    describe "custom video_url validation" do
      it "is valid with a valid YouTube video URL" do
        subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID456"
        expect(subject).to be_valid
      end

      it "is valid with a short YouTube video URL" do
        subject.video_url = "https://www.youtu.be/VIDEO_ID567"
        expect(subject).to be_valid
      end

      it "is invalid with a non-YouTube URL" do
        subject.video_url = "http://www.google.com"
        expect(subject).not_to be_valid
        expect(subject.errors[:video_url]).to be_present
        # expect(subject.errors[:video_url]).to include("must be a valid single YouTube video URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID or https://youtu.be/VIDEO_ID).")
      end

      it "is invalid with an invalid YouTube video ID format" do
        subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID###" # Invalid ID length
        expect(subject).not_to be_valid
        expect(subject.errors[:video_url]).to include("must be a valid single YouTube video URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID_11 or https://youtu.be/VIDEO_ID_11).")
      end
    end
  end

  context "callbacks" do
    describe "#set_embed_code" do
      it "sets the embed_code before validation if video_url is present" do
        subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID678"
        subject.valid? # Trigger validations and callbacks
        expect(subject.embed_code).to eq("VIDEO_ID678") # Expected video ID from the URL
      end

      it "does not overwrite embed_code if already set" do
        subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID789"
        subject.embed_code = "custom_embed_value"
        subject.valid?
        expect(subject.embed_code).to eq("custom_embed_value")
      end

      it "does not set embed_code if video_url is blank" do
        subject.video_url = nil
        subject.valid?
        expect(subject.embed_code).to be_nil
      end
    end
  end

  context "instance methods" do
    describe "#youtube_video_id" do
      it "returns the correct video ID for a long URL" do
        subject.video_url = "https://www.youtube.com/watch?v=VIDEO_ID890"
        expect(subject.youtube_video_id).to eq("VIDEO_ID890")
      end

      it "returns the correct video ID for a short URL" do
        subject.video_url = "https://youtu.be/VIDEO_ID098"
        expect(subject.youtube_video_id).to eq("VIDEO_ID098")
      end

      it "returns nil for an invalid URL" do
        subject.video_url = "http://www.google.com"
        expect(subject.youtube_video_id).to be_nil
      end

      it "returns nil for a playlist URL" do
        subject.video_url = "https://youtube.com/playlist?list=VIDEO_ID987"
        expect(subject.youtube_video_id).to be_nil
      end
    end
  end

  context "class methods" do
    describe ".extract_youtube_video_id" do
      it "extracts ID from a standard watch URL" do
        url = "https://youtube.com/watch?v=VIDEO_ID876"
        expect(AureliusPress::ContentBlock::VideoEmbedBlock.extract_youtube_video_id(url)).to eq("VIDEO_ID876")
      end

      it "extracts ID from a short youtu.be URL" do
        url = "https://youtu.be/VIDEO_ID765"
        expect(AureliusPress::ContentBlock::VideoEmbedBlock.extract_youtube_video_id(url)).to eq("VIDEO_ID765")
      end

      it "returns nil for a non-YouTube URL" do
        url = "http://www.example.com"
        expect(AureliusPress::ContentBlock::VideoEmbedBlock.extract_youtube_video_id(url)).to be_nil
      end

      it "returns nil for a YouTube playlist URL" do
        url = "https://youtube.com/playlist?list=VIDEO_ID123"
        expect(AureliusPress::ContentBlock::VideoEmbedBlock.extract_youtube_video_id(url)).to be_nil
      end

      it "returns nil for a malformed YouTube URL" do
        url = "https://youtub.ecom/watc?hv=VIDEO_ID123"
        expect(AureliusPress::ContentBlock::VideoEmbedBlock.extract_youtube_video_id(url)).to be_nil
      end
    end
  end
end
