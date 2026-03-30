# == Schema Information
#
# Table name: aurelius_press_authors
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  slug             :string           not null
#  bio              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
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

  describe "scopes" do
    let!(:author_a) { create(:aurelius_press_catalogue_author, name: "Zeno") }
    let!(:author_b) { create(:aurelius_press_catalogue_author, name: "Aristo") }

    it ".ordered returns authors sorted by name" do
      # We check that our two new authors appear in the correct relative order
      ordered_names = described_class.ordered.pluck(:name)
      expect(ordered_names.index("Aristo")).to be < ordered_names.index("Zeno")
    end

    it ".with_quotes returns authors who have quotes through sources" do
      source = create(:aurelius_press_catalogue_source)
      create(:aurelius_press_catalogue_authorship, author: author_a, source: source)
      create(:aurelius_press_catalogue_quote, source: source)
      
      expect(described_class.with_quotes).to include(author_a)
      expect(described_class.with_quotes).not_to include(author_b)
    end

    it ".with_affiliate_links returns authors who have affiliate links" do
      create(:aurelius_press_catalogue_affiliate_link, linkable: author_b)
      
      expect(described_class.with_affiliate_links).to include(author_b)
      expect(described_class.with_affiliate_links).not_to include(author_a)
    end
  end

  describe "instance methods" do
    describe "#bio_summary" do
      it "returns a truncated bio" do
        long_bio = "A" * 150
        author = build(:aurelius_press_catalogue_author, bio: long_bio)
        expect(author.bio_summary.length).to eq(100)
        expect(author.bio_summary).to end_with("...")
      end

      it "returns nil if bio is blank" do
        author = build(:aurelius_press_catalogue_author, bio: nil)
        expect(author.bio_summary).to be_nil
      end
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      author = create(:aurelius_press_catalogue_author, name: "Zeno of Citium")
      expect(author.to_param).to eq("zeno-of-citium")
    end
  end
end
