# == Schema Information
#
# Table name: aurelius_press_group_memberships
#
#  id            :bigint           not null, primary key
#  group_id      :bigint           not null
#  user_id       :bigint           not null
#  role          :integer          default("member"), not null
#  status        :integer          default("active"), not null
#  invited_by_id :bigint
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe AureliusPress::Community::GroupMembership, type: :model do
  let!(:user_one) { create(:aurelius_press_user) }
  let!(:user_two) { create(:aurelius_press_user) }
  let!(:group_a) { create(:aurelius_press_community_group) }
  let!(:group_b) { create(:aurelius_press_community_group) }

  describe "associations" do
    it { is_expected.to belong_to(:user).class_name("AureliusPress::User") }
    it { is_expected.to belong_to(:group).class_name("AureliusPress::Community::Group") }
  end

  describe "validations" do
    # Test for successful creation with valid attributes
    it "is valid with valid attributes" do
      membership = described_class.new(user: user_one, group: group_a)
      expect(membership).to be_valid
      expect { membership.save! }.to_not raise_error
    end

    # Test that a GroupMembership requires a user
    it "is invalid without a user" do
      membership = described_class.new(group: group_a)
      expect(membership).to_not be_valid
      expect(membership.errors[:user]).to include("must exist")
    end

    # Test that a GroupMembership requires a group
    it "is invalid without a group" do
      membership = described_class.new(user: user_one)
      expect(membership).to_not be_valid
      expect(membership.errors[:group]).to include("must exist")
    end

    # Test for uniqueness: a user cannot be a member of the same group multiple times
    it "is invalid if the user is already a member of the group" do
      described_class.create!(user: user_one, group: group_a)

      duplicate_membership = described_class.new(user: user_one, group: group_a)
      expect(duplicate_membership).to_not be_valid
      # Expect error message specific to your uniqueness validation scope
      expect(duplicate_membership.errors[:group_id]).to include("User is already a member of this group.")
    end

    # Test that a user can be a member of different groups
    it "is valid if the user is a member of different groups" do
      described_class.create!(user: user_one, group: group_a)
      new_membership = described_class.new(user: user_one, group: group_b)
      expect(new_membership).to be_valid
      expect { new_membership.save! }.to_not raise_error
    end

    # Test that different users can be members of the same group
    it "is valid if different users are members of the same group" do
      described_class.create!(user: user_one, group: group_a)
      new_membership = described_class.new(user: user_two, group: group_a)
      expect(new_membership).to be_valid
      expect { new_membership.save! }.to_not raise_error
    end
  end
end
