# spec/models/document_spec.rb
require "rails_helper"

RSpec.describe Document, type: :model do
  # Test Validations
  describe "validations" do
    # Test presence of essential attributes
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) } # Uniqueness of slug is critical for friendly URLs
    it { should validate_presence_of(:user) } # Documents must belong to a user

    # Test the enums defined in the Document model
    it { should define_enum_for(:status).with_values([:draft, :published, :archived]) }
    it { should define_enum_for(:visibility).with_values([:private_to_owner, :private_to_group, :private_to_app_users, :public_to_www]) }
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

    # Test Action Text rich text association
    it { should have_rich_text(:content) }
    # Test Active Storage attachment association
    it { should have_one_attached(:document_file) }
  end

  # Test Callbacks / Custom Logic
  describe "callbacks" do
    # Test that the slug is automatically generated before validation on creation
    it "generates a slug from the title before creation if slug is blank" do
      document = build(:document, title: "My Test Document Title", slug: nil)
      document.valid? # Trigger validations and callbacks
      expect(document.slug).to eq("my-test-document-title")
    end

    # Test that an explicitly provided slug is not overridden
    it "does not overwrite an existing slug" do
      document = build(:document, title: "Original Title", slug: "custom-slug")
      document.valid?
      expect(document.slug).to eq("custom-slug")
    end
  end

  # Test STI behavior
  describe "STI behavior" do
    # Test that a Document can be created directly as the base type
    it "can be instantiated as a base Document" do
      document = create(:document)
      expect(document).to be_a(Document)
      expect(document.type).to be_nil # Or expect(document.type).to eq('Document') if you explicitly set it
    end

    # Test that child classes inherit from Document and have the correct type
    it "can be instantiated as a Page" do
      page = create(:page) # Uses the :page factory trait
      expect(page).to be_a(Page)
      expect(page.type).to eq("Page")
      expect(page).to be_a(Document) # Still a Document
    end

    it "can be instantiated as a BlogPost" do
      blog_post = create(:blog_post)
      expect(blog_post).to be_a(BlogPost)
      expect(blog_post.type).to eq("BlogPost")
    end

    it "can be instantiated as a JournalEntry" do
      journal_entry = create(:journal_entry)
      expect(journal_entry).to be_a(JournalEntry)
      expect(journal_entry.type).to eq("JournalEntry")
      expect(journal_entry.visibility).to eq("private_to_owner") # Test specific default
    end

    it "can be instantiated as a Note" do
      note = create(:note)
      expect(note).to be_a(Note)
      expect(note.type).to eq("Note")
      expect(note.visibility).to eq("private_to_owner") # Test specific default
    end
  end
end
