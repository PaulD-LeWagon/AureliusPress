require "rails_helper"

RSpec.describe AureliusPress::LikesController, type: :controller do
  let!(:user) { create(:aurelius_press_user) }
  let!(:quote) { create(:aurelius_press_catalogue_quote) }

  # Assuming authentication is mocked or bypassed for this example,
  # or we sign in a user if Devise is used properly in this controller.
  # The controller has `before_action :authenticate_user!` commented out in my implementation,
  # but in a real app it would be enabled.

  let(:valid_attributes) {
    { user_id: user.id, likeable_type: "AureliusPress::Catalogue::Quote", likeable_id: quote.id, state: "like" }
  }

  before { sign_in user }

  describe "POST #create" do
    it "creates a new Like" do
      expect {
        post :create, params: { like: valid_attributes }
      }.to change(AureliusPress::Community::Like, :count).by(1)
    end

    it "updates an existing Like" do
      like = create(:aurelius_press_community_like, user: user, likeable: quote, state: :like)
      expect {
        post :create, params: { like: valid_attributes.merge(state: "dislike") }
      }.to change(AureliusPress::Community::Like, :count).by(0)

      like.reload
      expect(like.state).to eq("dislike")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested like" do
      like = create(:aurelius_press_community_like, user: user, likeable: quote)
      expect {
        delete :destroy, params: { id: like.id }
      }.to change(AureliusPress::Community::Like, :count).by(-1)
    end
  end
end
