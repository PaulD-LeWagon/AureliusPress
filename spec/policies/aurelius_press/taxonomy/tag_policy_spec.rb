require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::TagPolicy, type: :policy do
  subject { described_class }

  let(:guest)     { nil }
  let(:reader)    { create(:aurelius_press_reader_user) }
  let(:user)      { create(:aurelius_press_user) }
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:admin)     { create(:aurelius_press_admin_user) }
  let(:superuser) { create(:aurelius_press_superuser_user) }
  let(:tag)       { create(:aurelius_press_taxonomy_tag) }

  permissions :index?, :show? do
    it { is_expected.to permit(guest, tag) }
    it { is_expected.to permit(reader, tag) }
    it { is_expected.to permit(user, tag) }
    it { is_expected.to permit(moderator, tag) }
    it { is_expected.to permit(admin, tag) }
    it { is_expected.to permit(superuser, tag) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, tag) }
    it { is_expected.not_to permit(reader, tag) }
    it { is_expected.not_to permit(user, tag) }
    it { is_expected.not_to permit(moderator, tag) }
    it { is_expected.to     permit(admin, tag) }
    it { is_expected.to     permit(superuser, tag) }
  end
end
