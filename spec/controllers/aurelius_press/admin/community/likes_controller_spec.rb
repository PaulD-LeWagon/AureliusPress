require "rails_helper"

RSpec.describe AureliusPress::Admin::Community::LikesController, type: :controller do
  render_views

  let!(:moderator_user) { create(:aurelius_press_moderator_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:quote) { create(:aurelius_press_catalogue_quote) }

  before { sign_in moderator_user }

  let(:valid_attributes) {
    { user_id: user.id, likeable_type: "AureliusPress::Catalogue::Quote", likeable_id: quote.id, state: "like" }
  }

  let(:invalid_attributes) {
    { user_id: nil }
  }

  describe "GET #index" do
    it "returns a success response" do
      create(:aurelius_press_community_like, user: user, likeable: quote)
      get :index
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Like" do
        expect {
          post :create, params: { aurelius_press_community_like: valid_attributes }
        }.to change(AureliusPress::Community::Like, :count).by(1)
      end
    end
  end
  # ... other actions similar to ReactionsController
end
