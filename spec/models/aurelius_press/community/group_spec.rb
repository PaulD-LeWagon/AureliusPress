# spec/models/aurelius_press/group_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Community::Group, type: :model do
  # Test factory validity
  it "has a valid factory" do
    expect(create(:aurelius_press_community_group)).to be_valid
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }

    it "ensures name uniqueness case-insensitively (enforced by Sluggable concern by appending a number if needed)" do
      create(:aurelius_press_community_group, name: "My Unique Group Name")
      duplicate_name_group = build(:aurelius_press_community_group, name: "my unique group name")
      puts "Validating duplicate name group: #{duplicate_name_group.slug.inspect}"
      duplicate_name_group.valid?
      expect(duplicate_name_group).to be_valid
      expect(duplicate_name_group.errors[:name]).to_not be_present
      expect(duplicate_name_group.slug).to eq("my-unique-group-name-1")
    end

    it { should allow_value("valid-slug-123").for(:slug) }

    subject { build(:aurelius_press_community_group) } # Re-establish subject for the remaining shoulda-matchers
    it { should validate_length_of(:description).is_at_most(1000).allow_blank }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:privacy_setting) }
  end

  context "enums" do
    it { should define_enum_for(:status).with_values(active: 0, pending_approval: 1, archived: 2, suspended: 3) }
    it { should define_enum_for(:privacy_setting).with_values(public_group: 0, private_group: 1, hidden_group: 2) }
  end

  context "associations" do
    it { should belong_to(:creator).class_name("AureliusPress::User") }
    it { should have_many(:group_memberships).class_name("AureliusPress::Community::GroupMembership").dependent(:destroy) }
    it { should have_many(:members).through(:group_memberships).source(:user) }
    it { should have_and_belong_to_many(:documents).class_name("AureliusPress::Document::Document") }
    it { should have_one_attached(:image) }
  end

  context "custom behaviours" do
    let(:group) { create(:aurelius_press_community_group) }
    let(:user_member) { create(:aurelius_press_user) }
    let(:document) { create(:aurelius_press_document_blog_post) }

    it "adds a member correctly" do
      group.group_memberships.create(user: user_member, role: :member)
      expect(group.members).to include(user_member)
    end

    it "can have documents" do
      group.documents << document
      expect(group.documents).to include(document)
    end
  end
end
