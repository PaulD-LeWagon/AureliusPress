# == Schema Information
#
# Table name: aurelius_press_sources
#
#  id               :bigint           not null, primary key
#  title            :string
#  description      :text
#  source_type      :integer
#  date             :date
#  isbn             :string
#  slug             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
require "rails_helper"

RSpec.describe AureliusPress::Catalogue::Source, type: :model do
  let!(:author_record) { create(:aurelius_press_catalogue_author) }
  let!(:source_record) { create(:aurelius_press_catalogue_source) } # For potential duplicates
  let!(:authorship_record) { create(:aurelius_press_catalogue_authorship, author: author_record, source: source_record) }
  let!(:quote_record) { create(:aurelius_press_catalogue_quote, source: source_record) }
  let!(:user_record) { create(:aurelius_press_user) } # For comments/likes
  let!(:comment_record) { create(:aurelius_press_fragment_comment, commentable: source_record, user: user_record) }
  let!(:like_record) { create(:aurelius_press_community_like, likeable: source_record, user: user_record) }
  let!(:affiliate_link_record) { create(:aurelius_press_catalogue_affiliate_link, linkable: source_record) }

  describe "associations" do
    it { is_expected.to have_many(:authorships).class_name("AureliusPress::Catalogue::Authorship").dependent(:destroy).inverse_of(:source) }
    it { is_expected.to have_many(:authors).through(:authorships).source(:author).inverse_of(:sources) }
    it { is_expected.to have_many(:quotes).class_name("AureliusPress::Catalogue::Quote").dependent(:destroy).inverse_of(:source) }
    it { is_expected.to have_many(:affiliate_links).class_name("AureliusPress::Catalogue::AffiliateLink").dependent(:destroy).inverse_of(:linkable) }
    it { is_expected.to have_many(:comments).class_name("AureliusPress::Fragment::Comment").dependent(:destroy).inverse_of(:commentable) }
    it { is_expected.to have_many(:likes).class_name("AureliusPress::Community::Like").dependent(:destroy).inverse_of(:likeable) }
  end

  describe "validations" do
    it "is valid with a title and date" do
      source = build(:aurelius_press_catalogue_source, title: "On the Shortness of Life", date: Date.current)
      expect(source).to be_valid
    end

    it "is invalid without a title" do
      source = build(:aurelius_press_catalogue_source, title: nil)
      expect(source).to_not be_valid
      expect(source.errors[:title]).to include("can't be blank")
    end

    it "is invalid without a date" do
      source = build(:aurelius_press_catalogue_source, date: nil)
      expect(source).to_not be_valid
      expect(source.errors[:date]).to include("can't be blank")
    end

    it "generates a slug from the title on creation" do
      source = create(:aurelius_press_catalogue_source, title: "Meditations Book 1")
      expect(source.slug).to eq("meditations-book-1")
    end
  end

  describe "enums" do
    it "defines a source_type enum" do
      expect(described_class.source_types).to include(
        book: 0,
        play: 1,
        poem: 2,
        manuscript: 3,
        journal: 4,
        letter: 5,
        article: 6,
        essay: 7,
        thesis: 8,
        speech: 9,
        lecture: 10,
        interview: 11,
        dialogue: 12,
        statute: 13,
        decree: 14,
        website: 15,
        email: 16,
        newsletter: 17,
        review: 18,
        blog: 19,
        vlog: 20,
        podcast: 21,
      )
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      source = create(:aurelius_press_catalogue_source, title: "Discourses")
      expect(source.to_param).to eq("discourses")
    end
  end
end
