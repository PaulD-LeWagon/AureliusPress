require "rails_helper"

RSpec.describe AureliusPress::Community::GroupPolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:creator)    { create(:aurelius_press_user) }
  let(:non_member) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:public_group) do
    create(:aurelius_press_community_group, creator: creator, privacy_setting: :public_group)
  end
  let(:private_group) do
    create(:aurelius_press_community_group, creator: creator, privacy_setting: :private_group)
  end

  permissions :index?, :create? do
    it { is_expected.not_to permit(guest, public_group) }
    it { is_expected.not_to permit(reader, public_group) }
    it { is_expected.to     permit(non_member, public_group) }
    it { is_expected.to     permit(creator, public_group) }
    it { is_expected.to     permit(moderator, public_group) }
    it { is_expected.to     permit(admin, public_group) }
    it { is_expected.to     permit(superuser, public_group) }
  end

  permissions :show? do
    context "on a public group" do
      it { is_expected.not_to permit(guest, public_group) }
      it { is_expected.not_to permit(reader, public_group) }
      it { is_expected.to     permit(non_member, public_group) }
      it { is_expected.to     permit(creator, public_group) }
      it { is_expected.to     permit(moderator, public_group) }
      it { is_expected.to     permit(admin, public_group) }
      it { is_expected.to     permit(superuser, public_group) }
    end

    context "on a private group (non-member)" do
      it { is_expected.not_to permit(non_member, private_group) }
      it { is_expected.to     permit(creator, private_group) }
      it { is_expected.to     permit(moderator, private_group) }
    end
  end

  permissions :update?, :destroy? do
    it { is_expected.not_to permit(guest, public_group) }
    it { is_expected.not_to permit(reader, public_group) }
    it { is_expected.not_to permit(non_member, public_group) }
    it { is_expected.to     permit(creator, public_group) }
    it { is_expected.to     permit(moderator, public_group) }
    it { is_expected.to     permit(admin, public_group) }
    it { is_expected.to     permit(superuser, public_group) }
  end
end
