require "rails_helper"

RSpec.describe "AureliusPress::Community::Likes", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:blog_post)  { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let!(:like)      { create(:aurelius_press_community_like, :like_state, user: owner, likeable: blog_post) }

  # ── POST /aurelius-press/community/likes ──────────────────────────────────

  describe "POST /aurelius-press/community/likes" do
    let(:valid_params) do
      { like: { likeable_gid: blog_post.to_global_id.to_s, state: "like" } }
    end

    context "when authenticated as a user" do
      before { sign_in other_user }

      it "creates a like record" do
        expect {
          post aurelius_press_community_likes_path, params: valid_params
        }.to change(AureliusPress::Community::Like, :count).by(1)
      end

      it "responds with success or redirect" do
        post aurelius_press_community_likes_path, params: valid_params
        expect(response).to have_http_status(:success).or have_http_status(:redirect)
      end

      it "toggles to no_reaction when posting the same state again" do
        post aurelius_press_community_likes_path, params: valid_params
        expect(AureliusPress::Community::Like.last.state).to eq("like")

        post aurelius_press_community_likes_path, params: valid_params
        expect(AureliusPress::Community::Like.last.state).to eq("no_reaction")
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_community_likes_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── DELETE /aurelius-press/community/likes/:id ────────────────────────────

  describe "DELETE /aurelius-press/community/likes/:id" do
    context "when authenticated as the like owner" do
      before { sign_in owner }

      it "destroys the like" do
        expect {
          delete aurelius_press_community_like_path(like)
        }.to change(AureliusPress::Community::Like, :count).by(-1)
      end

      it "responds with success or redirect" do
        delete aurelius_press_community_like_path(like)
        expect(response).to have_http_status(:success).or have_http_status(:redirect)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the like" do
        expect {
          delete aurelius_press_community_like_path(like)
        }.not_to change(AureliusPress::Community::Like, :count)
      end

      it "returns forbidden or redirects" do
        delete aurelius_press_community_like_path(like)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_community_like_path(like)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
