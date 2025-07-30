# spec/models/document_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Document::Document, type: :model do
  subject { create(:aurelius_press_document_blog_post, :with_belt_and_braces) }

  # Document::DOCUMENT_TYPES.each do |document_type|
  #   describe "validations for #{document_type}" do
  #     let(:document) { build(document_type.underscore.to_sym) }
  #     it "is valid with valid attributes" do
  #       expect(document).to be_valid
  #     end
  #     it "is invalid without a title" do
  #       document.title = nil
  #       expect(document).not_to be_valid
  #       expect(document.errors[:title]).to include("can't be blank")
  #     end
  #     it "is invalid without a slug" do
  #       document.slug = nil
  #       expect(document).not_to be_valid
  #       expect(document.errors[:slug]).to include("can't be blank")
  #     end
  #     it "is invalid without a user" do
  #       document.user = nil
  #       expect(document).not_to be_valid
  #       expect(document.errors[:user]).to include("must exist")
  #     end
  #     it "is invalid without a type" do
  #       document.type = nil
  #       expect(document).not_to be_valid
  #       expect(document.errors[:type]).to include("can't be blank")
  #     end
  #   end
  # end
  # Test Validations

  describe "validations" do
    # Create a valid existing document before running uniqueness tests
    # This document will have a user_id and other required fields from its
    # factory using a concrete subclass of Document (like BlogPost) to ensure all
    # validations are covered
    let!(:existing_document) { create(:aurelius_press_document_blog_post) }

    it { should validate_presence_of(:type) } # Ensures STI subclass is set
    it do
      should validate_inclusion_of(:type)
               .in_array(AureliusPress::Document::Document::namespaced_types)
               .with_message("must be a valid document type.")
    end
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:visibility) }
    it { should validate_presence_of(:user) }

    it {
      should define_enum_for(:status)
               .with_values([
                 "draft",
                 "published",
                 "archived",
               ])
    }
    it {
      should define_enum_for(:visibility)
               .with_values([
                 "private_to_owner",
                 "private_to_group",
                 "private_to_app_users",
                 "public_to_www",
               ])
    }

    it "has a slug generated automatically" do
      document = build(:aurelius_press_document_blog_post, title: "My Awesome Blog Post", slug: nil)
      expect(document.slug).to be_nil # Before validation/save
      document.valid? # This triggers the generate_slug callback
      expect(document.slug).to eq("my-awesome-blog-post")
    end
  end

  # Test Associations
  describe "associations" do
    # A Document belongs to a User
    it { should belong_to(:user) }
    # A Document can optionally belong to a Category
    it { should belong_to(:category).optional }
    # A Document has many ContentBlocks (and they should be destroyed if the document is deleted)
    it { should have_many(:content_blocks).dependent(:destroy) }
    # A Document has many Tags through Taggings (many-to-many relationship)
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
    # Document has many Comments (and they should be destroyed if the document is deleted)
    it { should have_many(:comments).dependent(:destroy) }
    # Document has many Likes (and they should be destroyed if the document is deleted)
    it { should have_many(:likes).dependent(:destroy) }
  end

  # Test Callbacks / Custom Logic
  describe "callbacks" do
    # Test that the slug is automatically generated before validation on creation
    it "generates a slug from the title before creation if slug is blank" do
      document = build(:aurelius_press_document_blog_post, title: "My Test Document Title", slug: nil)
      document.valid? # Trigger validations and callbacks
      expect(document.slug).to eq("my-test-document-title")
    end

    # Test that an explicitly provided slug is not overridden
    it "does not overwrite an existing slug" do
      document = build(:aurelius_press_document_blog_post, title: "Original Title", slug: "custom-slug")
      document.valid?
      expect(document.slug).to eq("custom-slug")
    end

    it "can update with a custom slug" do
      document = build(:aurelius_press_document_blog_post, title: "Original Title", slug: "first-custom-slug")
      document.valid? # Trigger validations and callbacks
      document.slug = "second-custom-slug"
      document.valid?
      expect(document.slug).to eq("second-custom-slug")
    end
  end

  # # Test STI behavior
  describe "STI behavior" do
    # Test that child classes inherit from Document and have the correct type
    it "can be instantiated as an AtomicBlogPost" do
      atomic_blog_post = create(:aurelius_press_document_atomic_blog_post)
      expect(atomic_blog_post).to be_a(AureliusPress::Document::AtomicBlogPost)
      expect(atomic_blog_post.type).to eq("AureliusPress::Document::AtomicBlogPost")
      expect(atomic_blog_post).to be_a(AureliusPress::Document::Document) # Still a Document
      expect(atomic_blog_post.visibility).to eq("public_to_www") # Test specific default
    end

    it "can be instantiated as a BlogPost" do
      blog_post = create(:aurelius_press_document_blog_post)
      expect(blog_post).to be_a(AureliusPress::Document::BlogPost)
      expect(blog_post.type).to eq("AureliusPress::Document::BlogPost")
      expect(blog_post).to be_a(AureliusPress::Document::Document) # Still a Document
      expect(blog_post.visibility).to eq("public_to_www") # Test specific default
    end

    it "can be instantiated as a JournalEntry" do
      journal_entry = create(:aurelius_press_document_journal_entry)
      expect(journal_entry).to be_a(AureliusPress::Document::JournalEntry)
      expect(journal_entry.type).to eq("AureliusPress::Document::JournalEntry")
      expect(journal_entry).to be_a(AureliusPress::Document::Document) # Still a Document
      expect(journal_entry.visibility).to eq("private_to_owner") # Test specific default
    end

    it "can be instantiated as a Page" do
      page = create(:aurelius_press_document_page) # Uses the :page factory trait
      expect(page).to be_a(AureliusPress::Document::Page)
      expect(page.type).to eq("AureliusPress::Document::Page")
      expect(page).to be_a(AureliusPress::Document::Document) # Still a Document
      expect(page.visibility).to eq("public_to_www") # Test specific default
    end
  end
end
