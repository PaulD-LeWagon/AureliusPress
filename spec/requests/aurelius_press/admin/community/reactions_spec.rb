require "rails_helper"

RSpec.describe "AureliusPress::Admin::Community::Reactions", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:quote) { create(:aurelius_press_catalogue_quote) }
  let(:reaction) { create(:aurelius_press_community_reaction, reactable: quote) }

  before do
    sign_in admin
  end

  describe "GET /aurelius-press/admin/community/reactions" do
    it "returns http success" do
      get aurelius_press_admin_community_reactions_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/community/reactions/:id" do
    it "returns http success" do
      get aurelius_press_admin_community_reaction_path(reaction)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/community/reactions/new" do
    it "returns http success" do
      get new_aurelius_press_admin_community_reaction_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /aurelius-press/admin/community/reactions" do
    let(:valid_params) do
      {
        aurelius_press_community_reaction: {
          user_id: admin.id,
          reactable_id: quote.id,
          reactable_type: "AureliusPress::Catalogue::Quote",
          emoji: "heart"
        }
      }
    end

    it "creates a new reaction" do
      expect {
        post aurelius_press_admin_community_reactions_path, params: valid_params
      }.to change(AureliusPress::Community::Reaction, :count).by(1)

      new_reaction = AureliusPress::Community::Reaction.last
      expect(new_reaction.emoji).to eq("heart")
      expect(response).to redirect_to(aurelius_press_admin_community_reaction_path(new_reaction))
    end
  end

  describe "GET /aurelius-press/admin/community/reactions/:id/edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_community_reaction_path(reaction)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /aurelius-press/admin/community/reactions/:id" do
    it "updates the reaction and redirects" do
      patch aurelius_press_admin_community_reaction_path(reaction), params: { aurelius_press_community_reaction: { emoji: "shocked_face" } }
      expect(reaction.reload.emoji).to eq("shocked_face")
      expect(response).to redirect_to(aurelius_press_admin_community_reaction_path(reaction))
    end
  end

  describe "DELETE /aurelius-press/admin/community/reactions/:id" do
    it "destroys the reaction and redirects" do
      reaction_to_delete = create(:aurelius_press_community_reaction)
      expect {
        delete aurelius_press_admin_community_reaction_path(reaction_to_delete)
      }.to change(AureliusPress::Community::Reaction, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_community_reactions_path)
    end
  end
end
