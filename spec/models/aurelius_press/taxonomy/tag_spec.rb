require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::Tag, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe "associations" do
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:documents).through(:taggings) }
  end

  describe "callbacks" do
    describe "#generate_slug" do
      it "generates a slug from the name if slug is blank on creation" do
        tag = build(:aurelius_press_taxonomy_tag, name: "My Awesome Tag", slug: nil)
        tag.validate # Trigger before_validation callback
        expect(tag.slug).to eq("my-awesome-tag")
      end

      it "does not overwrite an existing slug" do
        tag = build(:aurelius_press_taxonomy_tag, name: "Another Tag", slug: "pre-defined-slug")
        tag.validate
        expect(tag.slug).to eq("pre-defined-slug")
      end

      it "parameterizes the name correctly for slug generation" do
        tag = build(:aurelius_press_taxonomy_tag, name: "Test Tag with Spaces & Symbols!", slug: nil)
        tag.validate
        expect(tag.slug).to eq("test-tag-with-spaces-symbols")
      end

      it "does not generate a slug if name is not present" do
        tag = build(:aurelius_press_taxonomy_tag, name: nil, slug: nil)
        tag.validate # Will fail presence validation, but slug should remain nil
        expect(tag.slug).to be_nil
      end
    end
  end
end
