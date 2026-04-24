require "rails_helper"

RSpec.describe AureliusPress::Community::GroupMembershipPolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:creator)    { create(:aurelius_press_user) }
  let(:member)     { create(:aurelius_press_user) }
  let(:non_member) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:group)      { create(:aurelius_press_community_group, creator: creator) }
  let(:membership) do
    create(:aurelius_press_community_group_membership, group: group, user: member, status: :active)
  end

  permissions :create? do
    it { is_expected.not_to permit(guest, membership) }
    it { is_expected.not_to permit(reader, membership) }
    it { is_expected.to     permit(non_member, membership) }
    it { is_expected.to     permit(member, membership) }
    it { is_expected.to     permit(moderator, membership) }
    it { is_expected.to     permit(admin, membership) }
    it { is_expected.to     permit(superuser, membership) }
  end

  permissions :destroy? do
    it { is_expected.not_to permit(guest, membership) }
    it { is_expected.not_to permit(reader, membership) }
    it { is_expected.not_to permit(non_member, membership) }
    it { is_expected.to     permit(member, membership) }
    it { is_expected.to     permit(moderator, membership) }
    it { is_expected.to     permit(admin, membership) }
    it { is_expected.to     permit(superuser, membership) }
  end
end
