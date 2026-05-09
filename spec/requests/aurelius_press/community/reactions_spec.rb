require "rails_helper"

RSpec.describe "AureliusPress::Community::Reactions", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:blog_post)  { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let!(:reaction)  { create(:aurelius_press_community_reaction, user: owner, reactable: blog_post) }

  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  describe "DELETE /aurelius-press/community/reactions/:id" do
    context "when authenticated as the reaction owner" do
      before { sign_in owner }

      it "destroys the reaction" do
        expect {
          delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        }.to change(AureliusPress::Community::Reaction, :count).by(-1)
      end

      it "responds with turbo_stream media type" do
        delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "returns http success" do
        delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        expect(response).to have_http_status(:ok)
      end

      it "falls back to html redirect" do
        delete aurelius_press_community_reaction_path(reaction)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "redirects to root (Pundit not-authorized)" do
        delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the reaction" do
        expect {
          delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        }.not_to change(AureliusPress::Community::Reaction, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_community_reaction_path(reaction), headers: turbo_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
