require "rails_helper"

RSpec.describe AureliusPress::Catalogue::SourcePolicy, type: :policy do
  subject { described_class }

  let(:guest)     { nil }
  let(:reader)    { create(:aurelius_press_reader_user) }
  let(:user)      { create(:aurelius_press_user) }
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:admin)     { create(:aurelius_press_admin_user) }
  let(:superuser) { create(:aurelius_press_superuser_user) }
  let(:source)    { create(:aurelius_press_catalogue_source) }

  permissions :index?, :show? do
    it { is_expected.to permit(guest, source) }
    it { is_expected.to permit(reader, source) }
    it { is_expected.to permit(user, source) }
    it { is_expected.to permit(moderator, source) }
    it { is_expected.to permit(admin, source) }
    it { is_expected.to permit(superuser, source) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, source) }
    it { is_expected.not_to permit(reader, source) }
    it { is_expected.not_to permit(user, source) }
    it { is_expected.not_to permit(moderator, source) }
    it { is_expected.to     permit(admin, source) }
    it { is_expected.to     permit(superuser, source) }
  end
end
