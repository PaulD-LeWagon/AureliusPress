require "rails_helper"

RSpec.describe AureliusPress::Catalogue::Authorship, type: :model do
  let!(:author) { create(:aurelius_press_catalogue_author) }
  let!(:source) { create(:aurelius_press_catalogue_source) }

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name("AureliusPress::Catalogue::Author").inverse_of(:authorships) }
    it { is_expected.to belong_to(:source).class_name("AureliusPress::Catalogue::Source").inverse_of(:authorships) }
  end

  describe "validations" do
    it "is valid with an author and a source" do
      authorship = build(:aurelius_press_catalogue_authorship, author: author, source: source)
      expect(authorship).to be_valid
    end

    it "is invalid without an author" do
      authorship = build(:aurelius_press_catalogue_authorship, author: nil, source: source)
      expect(authorship).to_not be_valid
      expect(authorship.errors[:author]).to include("must exist")
    end

    it "is invalid without a source" do
      authorship = build(:aurelius_press_catalogue_authorship, author: author, source: nil)
      expect(authorship).to_not be_valid
      expect(authorship.errors[:source]).to include("must exist")
    end

    it "ensures uniqueness of author scoped to source" do
      create(:aurelius_press_catalogue_authorship, author: author, source: source) # Create existing authorship
      duplicate_authorship = build(:aurelius_press_catalogue_authorship, author: author, source: source)
      expect(duplicate_authorship).to_not be_valid
      expect(duplicate_authorship.errors[:author_id]).to include("this author is already associated with this source")
    end
  end

  describe "enums" do
    it "defines a role enum" do
      expect(described_class.roles).to include(
        author: 0, co_author: 1, editor: 2, translator: 3, commentator: 4,
        compiler: 5, introducer: 6, contributor: 7,
      )
    end

    it "can set a role" do
      authorship = build(:aurelius_press_catalogue_authorship, author: author, source: source, role: :editor)
      expect(authorship.editor?).to be_truthy
    end
  end
end
