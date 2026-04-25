require "rails_helper"

RSpec.describe AureliusPress::Community::LikePolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:likeable)   { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let(:like)       { create(:aurelius_press_community_like, user: owner, likeable: likeable) }

  permissions :create? do
    it { is_expected.not_to permit(guest, like) }
    it { is_expected.not_to permit(reader, like) }
    it { is_expected.to     permit(other_user, like) }
    it { is_expected.to     permit(owner, like) }
    it { is_expected.to     permit(moderator, like) }
    it { is_expected.to     permit(admin, like) }
    it { is_expected.to     permit(superuser, like) }
  end

  permissions :update?, :destroy? do
    it { is_expected.not_to permit(guest, like) }
    it { is_expected.not_to permit(reader, like) }
    it { is_expected.not_to permit(other_user, like) }
    it { is_expected.to     permit(owner, like) }
    it { is_expected.to     permit(moderator, like) }
    it { is_expected.to     permit(admin, like) }
    it { is_expected.to     permit(superuser, like) }
  end
end
