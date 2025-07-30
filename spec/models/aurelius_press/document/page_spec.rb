require "rails_helper"

RSpec.describe AureliusPress::Document::Page, type: :model do
  # Use the factory to create a Page with all necessary attributes and associations
  # The :with_belt_and_braces trait ensures all attributes are set for a complete
  # Document subclass, including content blocks, category, tags, and notes.
  subject { create(:aurelius_press_document_page, :with_belt_and_braces, :with_one_of_each_content_block) }

  context "associations" do
    it { should have_many(:content_blocks).dependent(:destroy) }
    # Test the dynamically generated delegated type scopes
    it "has dynamically generated associations for contentable types" do
      expect(subject.content_blocks.image_blocks.count).to eq(1)
      expect(subject.content_blocks.rich_text_blocks.count).to eq(1)
      expect(subject.content_blocks.gallery_blocks.count).to eq(1)
      expect(subject.content_blocks.video_embed_blocks.count).to eq(1)

      expect(subject.content_blocks.merge(AureliusPress::ContentBlock::ContentBlock.image_blocks).count).to eq(1)
      expect(subject.content_blocks.merge(AureliusPress::ContentBlock::ContentBlock.rich_text_blocks).count).to eq(1)
      expect(subject.content_blocks.merge(AureliusPress::ContentBlock::ContentBlock.gallery_blocks).count).to eq(1)
      expect(subject.content_blocks.merge(AureliusPress::ContentBlock::ContentBlock.video_embed_blocks).count).to eq(1)

      expect(subject.content_blocks).to all(be_a(AureliusPress::ContentBlock::ContentBlock))
    end
  end

  context "page specifications" do
    it "is a valid Page" do
      expect(subject).to be_valid
      expect(subject).to be_a(AureliusPress::Document::Page)
    end

    it "inherits from Document" do
      expect(described_class.superclass).to eq(AureliusPress::Document::Document)
    end

    it "sets the correct type for STI" do
      expect(subject.type).to eq("AureliusPress::Document::Page")
    end

    it "has valid attributes" do
      expect(subject.title).to be_present
      expect(subject.slug).to be_present
      expect(subject.subtitle).to be_present
      expect(subject.description).to be_present
      expect(subject.status).to eq("published")
      expect(subject.visibility).to eq("public_to_www")
      expect(subject.published_at).to be_present
      expect(subject.published_at).to be < Time.current
      expect(subject.user).to be_present
      expect(subject.user).to be_a(AureliusPress::User)
    end

    it "has a valid author (User)" do
      expect(subject.user).to be_present
      expect(subject.user).to be_valid
      expect(subject.user).to be_persisted
      expect(subject.user).to be_a(AureliusPress::User)
    end

    it "has a valid category" do
      expect(subject.category).to be_present
      expect(subject.category).to be_a(AureliusPress::Taxonomy::Category)
    end

    it "has valid tags" do
      expect(subject.tags).to be_present
      expect(subject.tags.count).to eq(3)
      expect(subject.tags.first).to be_a(AureliusPress::Taxonomy::Tag)
    end

    it "has valid likes" do
      expect(subject.likes).to be_present
      expect(subject.likes.count).to eq(3)
      expect(subject.likes.first).to be_a(AureliusPress::Community::Like)
    end

    it "can [NOT] have comments" do
      expect(subject.comments_enabled).to be false
      expect(subject.comments).to be_empty
    end
  end

  describe "Delegated Type Content Blocks" do
    it "allows creating content blocks with an ImageBlock contentable" do
      page = create(:aurelius_press_document_page)
      image_content = create(:aurelius_press_content_block_image_block) # This is the actual image data
      content_block_instance = nil
      expect {
        # Create the ContentBlock that links the page to the specific image_content
        content_block_instance = AureliusPress::ContentBlock::ContentBlock.create(document: page, contentable: image_content)
      }.to change(AureliusPress::ContentBlock::ContentBlock, :count).by(1)
      expect(content_block_instance).to be_persisted
      expect(content_block_instance.contentable).to eq(image_content) # The contentable is the ImageBlock
      expect(page.content_blocks).to include(content_block_instance)
    end

    it "allows creating content blocks with a RichTextBlock contentable" do
      page = build(:aurelius_press_document_page)
      # @bug: Using create with ActionText blocks Or at least RichTextBlock
      # triggers an error about missing or empty contentable (which is actually
      # the RichTextBlock itself). ???
      rich_text_content = build(:aurelius_press_content_block_rich_text_block)
      content_block_instance = nil
      expect {
        # Create the ContentBlock that links the page to the specific rich_text_content
        content_block_instance = AureliusPress::ContentBlock::ContentBlock.create(document: page, contentable: rich_text_content)
      }.to change(AureliusPress::ContentBlock::ContentBlock, :count).by(1)
      expect(content_block_instance).to be_persisted
      expect(content_block_instance.contentable).to eq(rich_text_content)
      expect(page.content_blocks).to include(content_block_instance)
    end

    it "creates multiple types of content blocks via trait and retrieves them" do
      # Using trait :with_one_of_each_content_block
      subject.save! # Ensure the subject is saved to the database
      expect(subject.content_blocks.count).to eq(AureliusPress::ContentBlock::ContentBlock.get_namespaced_types.count)
      subject.content_blocks.each do |block|
        expect(block).to be_a(AureliusPress::ContentBlock::ContentBlock)
        expect(block.contentable).to be_present
        expect(block.contentable).to be_a(AureliusPress::ContentBlock::ContentBlock.get_namespaced_types.map(&:constantize).include(block.contentable.class))
      end
    end
  end
end
