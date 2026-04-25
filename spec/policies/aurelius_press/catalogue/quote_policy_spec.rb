require "rails_helper"

RSpec.describe AureliusPress::Catalogue::QuotePolicy, type: :policy do
  subject { described_class }

  let(:guest)     { nil }
  let(:reader)    { create(:aurelius_press_reader_user) }
  let(:user)      { create(:aurelius_press_user) }
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:admin)     { create(:aurelius_press_admin_user) }
  let(:superuser) { create(:aurelius_press_superuser_user) }
  let(:source)    { create(:aurelius_press_catalogue_source) }
  let(:quote)     { create(:aurelius_press_catalogue_quote, source: source) }

  permissions :index?, :show? do
    it { is_expected.to permit(guest, quote) }
    it { is_expected.to permit(reader, quote) }
    it { is_expected.to permit(user, quote) }
    it { is_expected.to permit(moderator, quote) }
    it { is_expected.to permit(admin, quote) }
    it { is_expected.to permit(superuser, quote) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, quote) }
    it { is_expected.not_to permit(reader, quote) }
    it { is_expected.not_to permit(user, quote) }
    it { is_expected.not_to permit(moderator, quote) }
    it { is_expected.to     permit(admin, quote) }
    it { is_expected.to     permit(superuser, quote) }
  end
end
