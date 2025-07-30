require "rails_helper"

RSpec.describe AureliusPress::Catalogue::Author, type: :model do
  # The primary subject of the test is the author_record.
  # Use create! to ensure it and its direct associations are persisted.
  let!(:author_record) { create(:aurelius_press_catalogue_author, name: "Marcus Aurelius") }

  # Explicitly create intermediate records for 'has_many through' chains
  # This makes the test setup clear and directly reflects the associations.
  let!(:source_record) { create(:aurelius_press_catalogue_source, title: "Meditations") }
  # Create the Authorship linking the specific author_record and source_record
  let!(:authorship_record) { create(:aurelius_press_catalogue_authorship, author: author_record, source: source_record) }
  # Create a Quote associated with the source_record, which is linked to author_record
  let!(:quote_record) { create(:aurelius_press_catalogue_quote, source: source_record, text: "The happiness of your life depends upon the quality of your thoughts.") }

  # Other polymorphic associations - ensure they are correctly linked
  let!(:user_record) { create(:aurelius_press_user) }
  let!(:comment_record) { create(:aurelius_press_fragment_comment, commentable: author_record, user: user_record) }
  let!(:like_record) { create(:aurelius_press_community_like, likeable: author_record, user: user_record) }
  let!(:affiliate_link_record) { create(:aurelius_press_catalogue_affiliate_link, linkable: author_record) }

  subject { author_record }

  describe "associations" do
    it { is_expected.to have_many(:authorships).class_name("AureliusPress::Catalogue::Authorship").dependent(:destroy).inverse_of(:author) }
    it { is_expected.to have_many(:sources).through(:authorships).source(:source).inverse_of(:authors) }
    it { is_expected.to have_many(:quotes).through(:sources).source(:quotes).class_name('AureliusPress::Catalogue::Quote') }
    it { is_expected.to have_many(:affiliate_links).class_name("AureliusPress::Catalogue::AffiliateLink").dependent(:destroy).inverse_of(:linkable) }
    it { is_expected.to have_many(:comments).class_name("AureliusPress::Fragment::Comment").dependent(:destroy).inverse_of(:commentable) }
    it { is_expected.to have_many(:likes).class_name("AureliusPress::Community::Like").dependent(:destroy).inverse_of(:likeable) }
  end

  describe "validations" do
    it "is valid with a name" do
      author = build(:aurelius_press_catalogue_author, name: "Seneca")
      expect(author).to be_valid
    end

    it "is invalid without a name" do
      author = build(:aurelius_press_catalogue_author, name: nil)
      expect(author).to_not be_valid
      expect(author.errors[:name]).to include("can't be blank")
    end

    it "generates a slug on creation" do
      author = create(:aurelius_press_catalogue_author, name: "Epictetus")
      expect(author.slug).to eq("epictetus")
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      author = create(:aurelius_press_catalogue_author, name: "Zeno of Citium")
      expect(author.to_param).to eq("zeno-of-citium")
    end
  end
end
