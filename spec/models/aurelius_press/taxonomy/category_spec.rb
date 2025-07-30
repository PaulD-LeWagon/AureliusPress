require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::Category, type: :model do
  context "associations" do
    it { should have_many(:documents) }
  end

  context "validations" do
    # Use build to prevent saving to the database for uniqueness checks initially
    subject { build(:aurelius_press_taxonomy_category) }
    let!(:existing_category) { create(:aurelius_press_taxonomy_category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    # A valid slug is now enforced by the Sluggable concern
    # and so is no longer tested here!
    # it { should validate_uniqueness_of(:slug) }
  end

  context "callbacks" do
    describe "slug generation" do
      it "generates a slug from the name if slug is blank on creation" do
        category = build(:aurelius_press_taxonomy_category, name: "My Awesome Category", slug: nil)
        category.validate # Trigger before_validation callback
        expect(category.slug).to eq("my-awesome-category")
      end

      it "does not overwrite an existing slug" do
        category = build(:aurelius_press_taxonomy_category, name: "Another Category", slug: "pre-defined-slug")
        category.validate
        expect(category.slug).to eq("pre-defined-slug")
      end

      it "parameterizes the name correctly for slug generation" do
        category = build(:aurelius_press_taxonomy_category, name: "Test Category with Spaces & Symbols!", slug: nil)
        category.validate
        expect(category.slug).to eq("test-category-with-spaces-symbols")
      end

      it "triggers validations correctly if name and slug are not provided" do
        category = build(:aurelius_press_taxonomy_category, name: nil, slug: nil)
        category.validate
        expect(category.slug).to be_nil
        expect(category.errors[:slug]).to include("can't be blank")
        expect(category.errors[:name]).to include("can't be blank")
      end
    end
  end
end
