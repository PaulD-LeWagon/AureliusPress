# spec/models/blog_post_spec.rb
require "rails_helper"

RSpec.describe AtomicBlogPost, type: :model do
  # Ensure the factory is valid and the model is set up correctly
  describe "The Specification" do
    it "has a valid factory" do
      expect(build(:atomic_blog_post)).to be_valid
      expect(create(:atomic_blog_post)).to be_persisted
    end
    it "inherits from Document" do
      expect(described_class.superclass).to eq(Document)
    end
    it "sets the correct type for STI [AtomicBlogPost]" do
      atomic_blog_post = create(:atomic_blog_post)
      expect(atomic_blog_post.type).to eq("AtomicBlogPost")
    end
  end

  # Test Validations
  describe "validations" do
    it { should validate_presence_of(:type) } # Ensures STI subclass is set
    it { should validate_inclusion_of(:type).in_array(["AtomicBlogPost"]) }
    it { should validate_presence_of(:content) }
  end

  describe "when document_file is attached" do
    it "is valid with a PNG image" do
      atomic_blog_post = build(:atomic_blog_post)
      atomic_blog_post.document_file.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.png")),
        filename: "test_image.png",
        content_type: "image/png",
      )
      expect(atomic_blog_post).to be_valid
    end

    # it "is valid with a JPEG image" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.jpeg")),
    #     filename: "test_image.jpeg",
    #     content_type: "image/jpeg",
    #   )
    #   expect(atomic_blog_post).to be_valid
    # end

    # it "is valid with a WebP image" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.webp")),
    #     filename: "test_image.webp",
    #     content_type: "image/webp",
    #   )
    #   expect(atomic_blog_post).to be_valid
    # end

    # it "is valid with a GIF image" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.gif")),
    #     filename: "test_image.gif",
    #     content_type: "image/gif",
    #   )
    #   expect(atomic_blog_post).to be_valid
    # end

    # it "is valid with an SVG image" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.svg")),
    #     filename: "test_image.svg",
    #     content_type: "image/svg+xml", # Note: SVG MIME type is image/svg+xml
    #   )
    #   expect(atomic_blog_post).to be_valid
    # end

    # it "is invalid with a PDF file" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_document.pdf")),
    #     filename: "test_document.pdf",
    #     content_type: "application/pdf",
    #   )
    #   expect(atomic_blog_post).not_to be_valid
    #   expect(atomic_blog_post.errors[:document_file]).to include("must be a PNG, JPEG, WebP, GIF, or SVG image.")
    # end

    # it "is invalid with a plain text file" do
    #   atomic_blog_post = build(:atomic_blog_post)
    #   atomic_blog_post.document_file.attach(
    #     io: File.open(Rails.root.join("spec", "fixtures", "files", "test_text.txt")),
    #     filename: "test_text.txt",
    #     content_type: "text/plain",
    #   )
    #   expect(atomic_blog_post).not_to be_valid
    #   expect(atomic_blog_post.errors[:document_file]).to include("must be a PNG, JPEG, WebP, GIF, or SVG image.")
    # end
  end

  describe "when document_file is not attached" do
    it "is valid" do
      atomic_blog_post = build(:atomic_blog_post) # By default, document_file should not be attached
      expect(atomic_blog_post).to be_valid # Validation should be skipped
    end
  end

  describe "associations" do
    it { should have_rich_text(:content) }
    it { should have_one_attached(:document_file) }
  end

  describe "after_initialize callbacks" do
    it "sets default visibility to public_to_www" do
      atomic_blog_post = create(:atomic_blog_post)
      expect(atomic_blog_post.visibility).to eq("public_to_www")
    end
    it "sets published_at to current time if published" do
      atomic_blog_post = create(:atomic_blog_post, :published)
      expect(atomic_blog_post.published_at).to be_within(1.second).of(Time.current)
    end
  end

  describe "#published?" do
    it "returns true if published_at is present and in the past" do
      atomic_blog_post = build(:atomic_blog_post, :published_1_day_ago)
      expect(atomic_blog_post.published?).to be true
    end

    it "returns false if published_at is nil" do
      atomic_blog_post = build(:atomic_blog_post, :not_published)
      expect(atomic_blog_post.published?).to be false
    end

    it "returns false if published_at is in the future" do
      atomic_blog_post = build(:atomic_blog_post, :published_tomorrow)
      expect(atomic_blog_post.published?).to be false
    end
  end

  describe "a new AtomicBlogPost" do
    let(:test_atomic_blog_post) { create(:atomic_blog_post, :with_3_comments) }

    it "has a default visibility of public_to_www" do
      expect(test_atomic_blog_post.visibility).to eq("public_to_www")
    end

    it "has a status of published" do
      expect(test_atomic_blog_post.status).to eq("published")
    end

    it "has 3 comments" do
      expect(test_atomic_blog_post.comments.count).to eq(3)
    end

    it "has comments enabled" do
      expect(test_atomic_blog_post.comments_enabled).to be true
    end

    it "has a valid content" do
      expect(test_atomic_blog_post.content).to be_present
    end

    it "has a valid document_file" do
      expect(test_atomic_blog_post.document_file).to be_attached
      expect(test_atomic_blog_post.document_file.content_type).to match(%r{image/(png|jpg|jpeg|gif|webp|svg\+xml)})
    end
  end
end
