require "rails_helper"

RSpec.describe AureliusPress::Fragment::NotePolicy, type: :policy do
  subject { described_class }

  let(:guest)      { nil }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }
  let(:notable)    { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let(:note)       { create(:aurelius_press_fragment_note, user: owner, notable: notable) }

  permissions :index?, :create? do
    it { is_expected.not_to permit(guest, note) }
    it { is_expected.not_to permit(reader, note) }
    it { is_expected.to     permit(other_user, note) }
    it { is_expected.to     permit(owner, note) }
    it { is_expected.to     permit(moderator, note) }
    it { is_expected.to     permit(admin, note) }
    it { is_expected.to     permit(superuser, note) }
  end

  permissions :show?, :update?, :destroy? do
    it { is_expected.not_to permit(guest, note) }
    it { is_expected.not_to permit(reader, note) }
    it { is_expected.not_to permit(other_user, note) }
    it { is_expected.to     permit(owner, note) }
    it { is_expected.to     permit(moderator, note) }
    it { is_expected.to     permit(admin, note) }
    it { is_expected.to     permit(superuser, note) }
  end

  describe "Scope" do
    subject(:scope) { described_class::Scope.new(actor, AureliusPress::Fragment::Note).resolve }

    let!(:my_note)    { create(:aurelius_press_fragment_note, user: owner, notable: notable) }
    let!(:other_note) { create(:aurelius_press_fragment_note, user: other_user, notable: notable) }

    context "when actor is the owner" do
      let(:actor) { owner }

      it "returns only own notes" do
        expect(scope).to include(my_note)
        expect(scope).not_to include(other_note)
      end
    end

    context "when actor is a power user" do
      let(:actor) { superuser }

      it "returns all notes" do
        expect(scope).to include(my_note, other_note)
      end
    end
  end
end
