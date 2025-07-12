# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  # Test basic validations provided by Devise and custom ones
  describe "validations" do
    # Test presence of email
    it { should validate_presence_of(:email) }
    # Test uniqueness of email, case insensitive
    it { should validate_uniqueness_of(:email).case_insensitive }
    # Test password presence and length (Devise defaults)
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) } # Default Devise min_length

    # Test presence of bio
    it { should validate_presence_of(:bio) } # Assuming bio is required

    # Test the enum for roles
    it { should define_enum_for(:role).with_values([:user, :moderator, :admin, :superuser]) }
  end

  # Test Active Storage attachment for avatar
  describe "attachments" do
    it "can have an avatar attached" do
      user = FactoryBot.create(:user)
      # Check if the avatar is attached
      expect(user.avatar).to be_attached
      # Optionally check content type or filename
      expect(user.avatar.filename.to_s).to eq("test_avatar.png")
      expect(user.avatar.content_type).to eq("image/png")
    end
  end

  # Test default role assignment
  describe "callbacks" do
    it "sets a default role of :user on creation" do
      user = FactoryBot.build(:user, role: nil) # Build without a role
      user.save # Save to trigger callbacks
      expect(user.role).to eq("user")
    end

    it "does not override an explicitly set role" do
      user = FactoryBot.create(:user, role: :admin)
      expect(user.role).to eq("admin")
    end
  end
end
