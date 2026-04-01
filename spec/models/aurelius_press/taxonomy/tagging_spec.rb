require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::Tagging, type: :model do
  describe "associations" do
    it { should belong_to(:tag).class_name("AureliusPress::Taxonomy::Tag") }
    it { should belong_to(:taggable) }
  end

  describe "validations" do
    subject { create(:aurelius_press_taxonomy_tagging) }
    
    it { should validate_presence_of(:tag) }
    it { should validate_presence_of(:taggable) }
    it { should validate_uniqueness_of(:tag_id).scoped_to([:taggable_id, :taggable_type]).with_message("already applied to this record") }
  end
end
