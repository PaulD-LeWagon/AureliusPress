# spec/models/tag_spec.rb
require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe "associations" do
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:documents).through(:taggings) }
  end
end
