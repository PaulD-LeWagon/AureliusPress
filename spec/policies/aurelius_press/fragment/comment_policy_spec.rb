require "rails_helper"

RSpec.describe AureliusPress::Fragment::CommentPolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:commentable) { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let(:comment)     { create(:aurelius_press_fragment_comment, user: owner, commentable: commentable) }

  permissions :index?, :show? do
    it { is_expected.not_to permit(guest, comment) }
    it { is_expected.to     permit(reader, comment) }
    it { is_expected.to     permit(other_user, comment) }
    it { is_expected.to     permit(owner, comment) }
    it { is_expected.to     permit(moderator, comment) }
    it { is_expected.to     permit(admin, comment) }
    it { is_expected.to     permit(superuser, comment) }
  end

  permissions :create? do
    it { is_expected.not_to permit(guest, comment) }
    it { is_expected.not_to permit(reader, comment) }
    it { is_expected.to     permit(other_user, comment) }
    it { is_expected.to     permit(owner, comment) }
    it { is_expected.to     permit(moderator, comment) }
    it { is_expected.to     permit(admin, comment) }
    it { is_expected.to     permit(superuser, comment) }
  end

  permissions :update?, :destroy? do
    it { is_expected.not_to permit(guest, comment) }
    it { is_expected.not_to permit(reader, comment) }
    it { is_expected.not_to permit(other_user, comment) }
    it { is_expected.to     permit(owner, comment) }
    it { is_expected.to     permit(moderator, comment) }
    it { is_expected.to     permit(admin, comment) }
    it { is_expected.to     permit(superuser, comment) }
  end

  describe "Scope" do
    subject(:scope) { described_class::Scope.new(actor, AureliusPress::Fragment::Comment).resolve }

    let!(:comment_on_public_doc) do
      create(:aurelius_press_fragment_comment,
             user: owner,
             commentable: create(:aurelius_press_document_blog_post, :visible_to_www))
    end
    let!(:comment_on_private_doc) do
      create(:aurelius_press_fragment_comment,
             user: owner,
             commentable: create(:aurelius_press_document_blog_post))
    end

    context "when actor is a superuser" do
      let(:actor) { superuser }

      it "returns all comments" do
        expect(scope).to include(comment_on_public_doc, comment_on_private_doc)
      end
    end

    context "when actor is a regular user" do
      let(:actor) { other_user }

      it "returns comments on documents accessible to the user" do
        expect(scope).to include(comment_on_public_doc)
      end
    end
  end
end
