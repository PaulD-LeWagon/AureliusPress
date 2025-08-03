# == Schema Information
#
# Table name: aurelius_press_quotes
#
#  id                :bigint           not null, primary key
#  text              :text
#  context           :string
#  source_id         :bigint           not null
#  original_quote_id :bigint
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  comments_enabled  :boolean          default(FALSE), not null
#
require "rails_helper"

RSpec.describe AureliusPress::Catalogue::Quote, type: :model do
  let!(:source_record) { create(:aurelius_press_catalogue_source) }
  let!(:original_quote_record) { create(:aurelius_press_catalogue_quote, source: source_record) }
  let!(:user_record) { create(:aurelius_press_user) } # For comments/likes
  let!(:comment_record) { create(:aurelius_press_fragment_comment, commentable: original_quote_record, user: user_record) }
  let!(:like_record) { create(:aurelius_press_community_like, likeable: original_quote_record, user: user_record) }

  describe "associations" do
    it { is_expected.to belong_to(:source).class_name("AureliusPress::Catalogue::Source").inverse_of(:quotes) }
    it { is_expected.to belong_to(:original_quote).class_name("AureliusPress::Catalogue::Quote").optional(true) }
    it { is_expected.to have_many(:variants).class_name("AureliusPress::Catalogue::Quote").with_foreign_key(:original_quote_id) }
    it { is_expected.to have_many(:comments).class_name("AureliusPress::Fragment::Comment").dependent(:destroy).inverse_of(:commentable) }
    it { is_expected.to have_many(:likes).class_name("AureliusPress::Community::Like").dependent(:destroy).inverse_of(:likeable) }
  end

  describe "validations" do
    it "is valid with text and a source" do
      quote = build(:aurelius_press_catalogue_quote, source: source_record, text: "New quote text.")
      expect(quote).to be_valid
    end

    it "is invalid without text" do
      quote = build(:aurelius_press_catalogue_quote, source: source_record, text: nil)
      expect(quote).to_not be_valid
      expect(quote.errors[:text]).to include("can't be blank")
    end

    it "is invalid without a source" do
      quote = build(:aurelius_press_catalogue_quote, source: nil, text: "Some text.")
      expect(quote).to_not be_valid
      expect(quote.errors[:source]).to include("must exist")
    end

    it "allows optional original_quote" do
      quote = build(:aurelius_press_catalogue_quote, source: source_record, text: "Variant text.", original_quote: original_quote_record)
      expect(quote).to be_valid
      quote_without_original = build(:aurelius_press_catalogue_quote, source: source_record, text: "Original text.")
      expect(quote_without_original).to be_valid
    end

    it "generates a slug from sluggable_text and truncates to 30 characters" do
      quote = create(:aurelius_press_catalogue_quote, source: source_record, text: "This is a very long quote that will be truncated for slugging purposes.")
      expect(quote.slug).to eq("this-is-a-very-long-quote-that") # Assumes 30 char truncation from sluggable_text
    end
  end

  describe "#sluggable_text 30 characters (unparameterized)" do
    it "truncates long text for slugging" do
      long_text_quote = build(:aurelius_press_catalogue_quote, source: source_record, text: "This is a very long quote that will be truncated for slugging purposes and it goes on and on.")
      expect(long_text_quote.send(:sluggable_text)).to eq("This is a very long quote that") # Expects 30 chars
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      quote = create(:aurelius_press_catalogue_quote, source: source_record, text: "Short quote.")
      expect(quote.to_param).to eq("short-quote")
    end
  end

  describe "#source_authors" do
    let!(:author_one) { create(:aurelius_press_catalogue_author, name: "Author One") }
    let!(:author_two) { create(:aurelius_press_catalogue_author, name: "Author Two") }
    let!(:source_with_authors) { create(:aurelius_press_catalogue_source) }
    let!(:authorship_one) { create(:aurelius_press_catalogue_authorship, author: author_one, source: source_with_authors) }
    let!(:authorship_two) { create(:aurelius_press_catalogue_authorship, author: author_two, source: source_with_authors) }

    it "delegates authors to its source" do
      quote = create(:aurelius_press_catalogue_quote, source: source_with_authors, text: "Delegated text.")
      expect(quote.source_authors).to include(author_one, author_two)
      expect(quote.source_authors.count).to eq(2)
    end

    it "returns nil if source is nil and allow_nil is true" do
      quote = build(:aurelius_press_catalogue_quote, source: nil, text: "Text without source.")
      expect(quote.source_authors).to be_nil
    end
  end
end
