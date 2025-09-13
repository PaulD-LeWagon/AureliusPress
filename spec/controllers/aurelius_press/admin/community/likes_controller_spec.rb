require "rails_helper"

RSpec.describe AureliusPress::Admin::Community::LikesController, type: :controller do
  render_views # Ensure views are rendered for template checks

  let!(:moderator_user) { create(:aurelius_press_moderator_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:source) { create(:aurelius_press_catalogue_source) }
  let!(:quote) { create(:aurelius_press_catalogue_quote, source: source) }

  before do
    sign_in moderator_user
  end

  after do
    sign_out moderator_user
  end

  let(:record_attributes) {
    {
      user: user,
      likeable: quote,
      emoji: :heart
    }
  }

  # Valid attributes for CONTROLLER PARAMETERS (for testing successful creation)
  let(:param_attributes) {
    {
      user_id: user.id,
      likeable_type: "AureliusPress::Catalogue::Quote",
      likeable_id: quote.id,
      emoji: :heart
    }
  }

  # Invalid attributes for CONTROLLER PARAMETERS (for testing validation failures)
  let(:invalid_param_attributes) {
    {
      user_id: nil, # This will trigger the presence validation on user_id
      likeable_type: "AureliusPress::Catalogue::Quote",
      likeable_id: quote.id,
      emoji: nil
    }
  }

  describe "GET #index" do
    it "returns a successful response and assigns @likes" do
      create(:aurelius_press_community_like, record_attributes) # Use record_attributes for direct creation
      get :index
      expect(response).to be_successful
      expect(assigns(:likes)).to_not be_nil
      expect(assigns(:likes)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @like" do
      like = create(:aurelius_press_community_like, record_attributes) # Use record_attributes for direct creation
      get :show, params: { id: like.id }
      expect(response).to be_successful
      expect(assigns(:like)).to eq(like)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:like)).to be_a_new(AureliusPress::Community::Like)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Like" do
        expect {
          post :create, params: { aurelius_press_community_like: param_attributes } # Use param_attributes
        }.to change(AureliusPress::Community::Like, :count).by(1)
      end

      it "redirects to the created like" do
        post :create, params: { aurelius_press_community_like: param_attributes } # Use param_attributes
        expect(response).to redirect_to(aurelius_press_admin_community_like_path(AureliusPress::Community::Like.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Like" do
        expect {
          post :create, params: { aurelius_press_community_like: invalid_param_attributes } # Use invalid_param_attributes
        }.to_not change(AureliusPress::Community::Like, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_community_like: invalid_param_attributes } # Use invalid_param_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @like" do
      like = create(:aurelius_press_community_like, record_attributes) # Use record_attributes for direct creation
      get :edit, params: { id: like.id }
      expect(response).to be_successful
      expect(assigns(:like)).to eq(like)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:like_to_update) { create(:aurelius_press_community_like, record_attributes) }
      let(:new_valid_param_attributes) { { emoji: :shocked_face } }

      it "updates the requested like" do
        patch :update, params: { id: like_to_update.id, aurelius_press_community_like: new_valid_param_attributes }
        like_to_update.reload
        expect(like_to_update.emoji.to_sym).to eq(new_valid_param_attributes[:emoji])
      end

      it "redirects to the like" do
        patch :update, params: { id: like_to_update.id, aurelius_press_community_like: new_valid_param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_community_like_path(like_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:like_to_update) { create(:aurelius_press_community_like, record_attributes) }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: like_to_update.id, aurelius_press_community_like: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the like" do
        original_user_id = like_to_update.user_id
        patch :update, params: { id: like_to_update.id, aurelius_press_community_like: invalid_param_attributes }
        like_to_update.reload
        expect(like_to_update.user_id).to eq(original_user_id)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested like" do
      like = create(:aurelius_press_community_like, record_attributes) # Use record_attributes
      expect {
        delete :destroy, params: { id: like.id }
      }.to change(AureliusPress::Community::Like, :count).by(-1)
    end

    it "redirects to the likes list" do
      like = create(:aurelius_press_community_like, record_attributes) # Use record_attributes
      delete :destroy, params: { id: like.id }
      expect(response).to redirect_to(aurelius_press_admin_community_likes_url)
    end
  end
end
