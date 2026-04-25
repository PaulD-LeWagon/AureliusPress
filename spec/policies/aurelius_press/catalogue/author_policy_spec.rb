require "rails_helper"

RSpec.describe AureliusPress::Catalogue::AuthorPolicy, type: :policy do
  subject { described_class }

  let(:guest)     { nil }
  let(:reader)    { create(:aurelius_press_reader_user) }
  let(:user)      { create(:aurelius_press_user) }
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:admin)     { create(:aurelius_press_admin_user) }
  let(:superuser) { create(:aurelius_press_superuser_user) }
  let(:author)    { create(:aurelius_press_catalogue_author) }

  permissions :index?, :show? do
    it { is_expected.to permit(guest, author) }
    it { is_expected.to permit(reader, author) }
    it { is_expected.to permit(user, author) }
    it { is_expected.to permit(moderator, author) }
    it { is_expected.to permit(admin, author) }
    it { is_expected.to permit(superuser, author) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, author) }
    it { is_expected.not_to permit(reader, author) }
    it { is_expected.not_to permit(user, author) }
    it { is_expected.not_to permit(moderator, author) }
    it { is_expected.to     permit(admin, author) }
    it { is_expected.to     permit(superuser, author) }
  end
end
