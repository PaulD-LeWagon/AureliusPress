require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::Tagging, type: :model do
  let!(:document) { create(:aurelius_press_document_blog_post) }
  let!(:tag) { create(:aurelius_press_taxonomy_tag) }

  subject { build(:aurelius_press_taxonomy_tagging, document: document, tag: tag) }

  context "associations" do
    it { should belong_to(:document).required }
    it { should belong_to(:tag).required }
  end

  context "validations" do
    # Test presence validation for associated records
    it { should validate_presence_of(:document) }
    it { should validate_presence_of(:tag) }

    # Test the uniqueness validation
    describe "uniqueness of tag_id scoped to document_id" do
      # Create an initial tagging to test against
      before do
        create(:aurelius_press_taxonomy_tagging, document: document, tag: tag)
      end

      it "is invalid if the same tag is applied to the same document again" do
        expect(subject).not_to be_valid
        expect(subject.errors[:tag_id]).to include("already applied to this document")
      end

      it "is valid if the same tag is applied to a different document" do
        other_document = create(:aurelius_press_document_page) # Create a new document
        subject.document = other_document   # Associate the tagging with the new document
        expect(subject).to be_valid
      end

      it "is valid if a different tag is applied to the same document" do
        other_tag = create(:aurelius_press_taxonomy_tag) # Create a new tag
        subject.tag = other_tag    # Associate the tagging with the new tag
        expect(subject).to be_valid
      end
    end
  end
end
