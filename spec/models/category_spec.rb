require "rails_helper"

RSpec.describe Category, type: :model do
  context "associations" do
    it { should have_many(:documents) }
  end

  context "validations" do
    # Use build to prevent saving to the database for uniqueness checks initially
    subject { build(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }
  end

  context "callbacks" do
    describe "#generate_slug" do
      it "generates a slug from the name if slug is blank on creation" do
        category = build(:category, name: "My Awesome Category", slug: nil)
        category.validate # Trigger before_validation callback
        expect(category.slug).to eq("my-awesome-category")
      end

      it "does not overwrite an existing slug" do
        category = build(:category, name: "Another Category", slug: "pre-defined-slug")
        category.validate
        expect(category.slug).to eq("pre-defined-slug")
      end

      it "parameterizes the name correctly for slug generation" do
        category = build(:category, name: "Test Category with Spaces & Symbols!", slug: nil)
        category.validate
        expect(category.slug).to eq("test-category-with-spaces-symbols")
      end

      it "does not generate a slug if name is not present" do
        category = build(:category, name: nil, slug: nil)
        category.validate # Will fail presence validation, but slug should remain nil
        expect(category.slug).to be_nil
      end
    end
  end
end
