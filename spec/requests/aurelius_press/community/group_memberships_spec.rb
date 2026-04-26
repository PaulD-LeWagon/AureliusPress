require "rails_helper"

RSpec.describe "AureliusPress::Community::GroupMemberships", type: :request do
  let(:user)       { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:group)      { create(:aurelius_press_community_group) }

  # ── Create (join) ──────────────────────────────────────────────────────────

  describe "POST /aurelius-press/community/group-memberships (create)" do
    let(:valid_params) { { group_membership: { group_id: group.id } } }

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_community_group_memberships_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "creates a group membership" do
        expect {
          post aurelius_press_community_group_memberships_path, params: valid_params
        }.to change(AureliusPress::Community::GroupMembership, :count).by(1)
      end

      it "associates the membership with current_user" do
        post aurelius_press_community_group_memberships_path, params: valid_params
        expect(AureliusPress::Community::GroupMembership.last.user).to eq(user)
      end

      it "responds with turbo stream or redirect" do
        post aurelius_press_community_group_memberships_path, params: valid_params
        expect(response).to have_http_status(:ok).or redirect_to(anything)
      end

      context "when already a member" do
        before { create(:aurelius_press_community_group_membership, group: group, user: user) }

        it "does not create a duplicate membership" do
          expect {
            post aurelius_press_community_group_memberships_path, params: valid_params
          }.not_to change(AureliusPress::Community::GroupMembership, :count)
        end
      end
    end
  end

  # ── Destroy (leave) ────────────────────────────────────────────────────────

  describe "DELETE /aurelius-press/community/group-memberships/:id (destroy)" do
    let!(:membership) { create(:aurelius_press_community_group_membership, group: group, user: user) }

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_community_group_membership_path(membership)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as the member" do
      before { sign_in user }

      it "destroys the membership" do
        expect {
          delete aurelius_press_community_group_membership_path(membership)
        }.to change(AureliusPress::Community::GroupMembership, :count).by(-1)
      end

      it "responds with turbo stream or redirect" do
        delete aurelius_press_community_group_membership_path(membership)
        expect(response).to have_http_status(:ok).or redirect_to(anything)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the membership" do
        expect {
          delete aurelius_press_community_group_membership_path(membership)
        }.not_to change(AureliusPress::Community::GroupMembership, :count)
      end
    end
  end
end
