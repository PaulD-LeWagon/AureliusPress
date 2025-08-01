# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::User, type: :model do
  # Test basic validations provided by Devise and custom ones
  describe "validations" do
    # Test presence of email
    it { should validate_presence_of(:email) }
    # Test uniqueness of email, case insensitive
    it { should validate_uniqueness_of(:email).case_insensitive }
    # Test password presence and length (Devise defaults)
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) } # Default Devise min_length

    # Test the enum for roles
    it { should define_enum_for(:role).with_values(["user", "contributor", "subscriber", "moderator", "admin", "superuser"]) }
  end

  # Test Active Storage attachment for avatar
  describe "attachments" do
    it "can have an avatar attached" do
      user = create(:aurelius_press_user)
      # Check if the avatar is attached
      expect(user.avatar).to be_attached
      expect(user.avatar.filename.to_s).to eq("test_avatar.png")
      expect(user.avatar.content_type).to eq("image/png")
      expect(user.avatar).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  # Test default role assignment
  describe "callbacks" do
    it "sets a default role of :user on creation" do
      user = build(:aurelius_press_user) # Build without a role
      user.save # Save to trigger callbacks
      expect(user.role).to eq("user")
    end

    it "does not override an explicitly set role" do
      user = create(:aurelius_press_user, role: :admin)
      expect(user.role).to eq("admin")
    end
  end

  describe "a specification for a user" do
    it "has a valid factory" do
      expect(build(:aurelius_press_user)).to be_valid
    end

    it "is invalid without an email" do
      expect(build(:aurelius_press_user, email: nil)).not_to be_valid
    end

    it "is invalid without a password" do
      expect(build(:aurelius_press_user, password: nil)).not_to be_valid
    end

    context "associations" do
      let(:user) { create(:aurelius_press_user) }
      let(:group) { create(:aurelius_press_community_group) }

      it "can be a member of a group" do
        create(:aurelius_press_community_group_membership, user: user, group: group)
        expect(user.groups).to include(group)
        expect(user.groups.count).to eq(1)
      end

      it "has many group memberships" do
        create(:aurelius_press_community_group_membership, user: user, group: group)
        expect(user.aurelius_press_community_group_memberships.count).to eq(1)
      end
    end
  end
end
