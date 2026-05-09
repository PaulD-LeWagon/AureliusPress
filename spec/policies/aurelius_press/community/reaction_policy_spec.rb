require "rails_helper"

RSpec.describe AureliusPress::Community::ReactionPolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:reactable)  { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let(:reaction)   { create(:aurelius_press_community_reaction, user: owner, reactable: reactable) }

  permissions :create? do
    it { is_expected.not_to permit(guest, reaction) }
    it { is_expected.not_to permit(reader, reaction) }
    it { is_expected.to     permit(other_user, reaction) }
    it { is_expected.to     permit(owner, reaction) }
    it { is_expected.to     permit(moderator, reaction) }
    it { is_expected.to     permit(admin, reaction) }
    it { is_expected.to     permit(superuser, reaction) }
  end

  permissions :update?, :destroy? do
    it { is_expected.not_to permit(guest, reaction) }
    it { is_expected.not_to permit(reader, reaction) }
    it { is_expected.not_to permit(other_user, reaction) }
    it { is_expected.to     permit(owner, reaction) }
    it { is_expected.to     permit(moderator, reaction) }
    it { is_expected.to     permit(admin, reaction) }
    it { is_expected.to     permit(superuser, reaction) }
  end
end
