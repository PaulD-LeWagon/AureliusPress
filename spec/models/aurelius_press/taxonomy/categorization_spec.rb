require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::Categorization, type: :model do
  describe "associations" do
    it { should belong_to(:category).class_name("AureliusPress::Taxonomy::Category").inverse_of(:categorizations) }
    it { should belong_to(:categorizable) }
  end

  describe "validations" do
    subject { create(:aurelius_press_taxonomy_categorization) }
    
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:categorizable) }
    it { should validate_uniqueness_of(:category_id).scoped_to([:categorizable_id, :categorizable_type]).with_message("already assigned to this record") }
  end
end
