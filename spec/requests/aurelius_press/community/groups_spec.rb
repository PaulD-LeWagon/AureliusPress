require "rails_helper"

RSpec.describe "AureliusPress::Community::Groups", type: :request do
  let(:user)    { create(:aurelius_press_user) }
  let!(:public_group)  { create(:aurelius_press_community_group) }
  let!(:private_group) { create(:aurelius_press_community_group, :private_group) }

  # ── Index ──────────────────────────────────────────────────────────────────

  describe "GET /aurelius-press/community/groups (index)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get aurelius_press_community_groups_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get aurelius_press_community_groups_path
        expect(response).to have_http_status(:success)
      end

      it "lists public groups" do
        get aurelius_press_community_groups_path
        expect(response.body).to include(public_group.name)
      end
    end
  end

  # ── Show ───────────────────────────────────────────────────────────────────

  describe "GET /aurelius-press/community/groups/:slug (show)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get aurelius_press_community_group_path(public_group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success for a public group" do
        get aurelius_press_community_group_path(public_group)
        expect(response).to have_http_status(:success)
      end

      it "lists group members" do
        member = create(:aurelius_press_user)
        create(:aurelius_press_community_group_membership, group: public_group, user: member)
        get aurelius_press_community_group_path(public_group)
        expect(response.body).to include(member.email)
      end
    end
  end
end
