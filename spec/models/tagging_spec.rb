require "rails_helper"

RSpec.describe Tagging, type: :model do
  let!(:document) { create(:blog_post) }
  let!(:tag) { create(:tag) }

  subject { build(:tagging, document: document, tag: tag) }

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
        create(:tagging, document: document, tag: tag)
      end

      it "is invalid if the same tag is applied to the same document again" do
        expect(subject).not_to be_valid
        expect(subject.errors[:tag_id]).to include("already applied to this document")
      end

      it "is valid if the same tag is applied to a different document" do
        other_document = create(:page) # Create a new document
        subject.document = other_document   # Associate the tagging with the new document
        expect(subject).to be_valid
      end

      it "is valid if a different tag is applied to the same document" do
        other_tag = create(:tag) # Create a new tag
        subject.tag = other_tag    # Associate the tagging with the new tag
        expect(subject).to be_valid
      end
    end
  end
end
