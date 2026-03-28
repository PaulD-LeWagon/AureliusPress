require "rails_helper"

RSpec.describe AureliusPress::Community::ReactionsController, type: :controller do
  let!(:user) { create(:aurelius_press_user) }
  let!(:quote) { create(:aurelius_press_catalogue_quote) }

  let(:valid_attributes) {
    { user_id: user.id, reactable_type: "AureliusPress::Catalogue::Quote", reactable_id: quote.id, emoji: "thumbs_up" }
  }

  let(:invalid_attributes) {
    { user_id: user.id, reactable_type: "AureliusPress::Catalogue::Quote", reactable_id: quote.id, emoji: nil }
  }
  before do
    @request.env["devise.mapping"] = Devise.mappings[:aurelius_press_user]
    sign_in user
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Reaction" do
        expect {
          post :create, params: { reaction: valid_attributes }
        }.to change(AureliusPress::Community::Reaction, :count).by(1)
      end

      it "returns created status" do
        post :create, params: { reaction: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a Reaction" do
        expect {
          post :create, params: { reaction: invalid_attributes }
        }.to change(AureliusPress::Community::Reaction, :count).by(0)
      end

      it "returns unprocessable_entity status" do
        post :create, params: { reaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested reaction" do
      reaction = create(:aurelius_press_community_reaction, user: user, reactable: quote)
      expect {
        delete :destroy, params: { id: reaction.id }
      }.to change(AureliusPress::Community::Reaction, :count).by(-1)
    end
  end
end
