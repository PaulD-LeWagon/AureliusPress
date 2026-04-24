require "rails_helper"

RSpec.describe AureliusPress::Taxonomy::CategoryPolicy, type: :policy do
  subject { described_class }

  let(:guest)     { nil }
  let(:reader)    { create(:aurelius_press_reader_user) }
  let(:user)      { create(:aurelius_press_user) }
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:admin)     { create(:aurelius_press_admin_user) }
  let(:superuser) { create(:aurelius_press_superuser_user) }
  let(:category)  { create(:aurelius_press_taxonomy_category) }

  permissions :index?, :show? do
    it { is_expected.to permit(guest, category) }
    it { is_expected.to permit(reader, category) }
    it { is_expected.to permit(user, category) }
    it { is_expected.to permit(moderator, category) }
    it { is_expected.to permit(admin, category) }
    it { is_expected.to permit(superuser, category) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, category) }
    it { is_expected.not_to permit(reader, category) }
    it { is_expected.not_to permit(user, category) }
    it { is_expected.not_to permit(moderator, category) }
    it { is_expected.to     permit(admin, category) }
    it { is_expected.to     permit(superuser, category) }
  end
end
