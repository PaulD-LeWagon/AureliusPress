require "rails_helper"

RSpec.describe AureliusPress::Document::ContentBlockPolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:doc_owner)  { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:document)   { create(:aurelius_press_document_blog_post, :visible_to_www, user: doc_owner) }
  let(:content_block) do
    create(:aurelius_press_content_block_content_block, :as_rich_text_block, document: document)
  end

  permissions :index?, :show? do
    it { is_expected.to permit(guest, content_block) }
    it { is_expected.to permit(reader, content_block) }
    it { is_expected.to permit(other_user, content_block) }
    it { is_expected.to permit(doc_owner, content_block) }
    it { is_expected.to permit(moderator, content_block) }
    it { is_expected.to permit(admin, content_block) }
    it { is_expected.to permit(superuser, content_block) }
  end

  permissions :create?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, content_block) }
    it { is_expected.not_to permit(reader, content_block) }
    it { is_expected.not_to permit(other_user, content_block) }
    it { is_expected.to     permit(doc_owner, content_block) }
    it { is_expected.to     permit(moderator, content_block) }
    it { is_expected.to     permit(admin, content_block) }
    it { is_expected.to     permit(superuser, content_block) }
  end
end
