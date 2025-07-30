require "rails_helper"

RSpec.describe AureliusPress::Catalogue::AffiliateLink, type: :model do
  # Linkable instances (assuming these models can be linked)
  let!(:author_linkable) { create(:aurelius_press_catalogue_author) }
  let!(:source_linkable) { create(:aurelius_press_catalogue_source) }
  let!(:quote_linkable) { create(:aurelius_press_catalogue_quote, source: source_linkable) }

  describe "associations" do
    it { is_expected.to belong_to(:linkable) } # Polymorphic associations don't need class_name
  end

  describe "validations" do
    it "is valid with text, a valid URL, and a linkable object" do
      link = build(:aurelius_press_catalogue_affiliate_link, text: "Buy Book", url: "https://example.com/book", linkable: author_linkable)
      expect(link).to be_valid
    end

    it "is invalid without text" do
      link = build(:aurelius_press_catalogue_affiliate_link, text: nil, url: "https://example.com", linkable: author_linkable)
      expect(link).to_not be_valid
      expect(link.errors[:text]).to include("can't be blank")
    end

    it "is invalid without a URL" do
      link = build(:aurelius_press_catalogue_affiliate_link, text: "Buy Book", url: nil, linkable: author_linkable)
      expect(link).to_not be_valid
      expect(link.errors[:url]).to include("can't be blank")
    end

    it "is invalid with an improperly formatted URL" do
      link = build(:aurelius_press_catalogue_affiliate_link, text: "Buy Book", url: "not-a-url", linkable: author_linkable)
      expect(link).to_not be_valid
      expect(link.errors[:url]).to include("must be a valid URL")
    end

    it "is invalid without a linkable object" do
      link = build(:aurelius_press_catalogue_affiliate_link, text: "Buy Book", url: "https://example.com", linkable: nil)
      expect(link).to_not be_valid
      expect(link.errors[:linkable]).to include("can't be blank")
    end
  end
end
