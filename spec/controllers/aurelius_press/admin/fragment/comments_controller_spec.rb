require "rails_helper"

RSpec.describe AureliusPress::Admin::Fragment::CommentsController, type: :controller do
  render_views

  let!(:moderator_user) { create(:aurelius_press_moderator_user) }
  let!(:user) { create(:aurelius_press_user) }
  let!(:quote) { create(:aurelius_press_catalogue_quote) }

  before do
    sign_in moderator_user
  end

  after do
    sign_out moderator_user
  end

  let(:record_attributes) {
    { user: user, commentable: quote, content: "A fascinating insight!" }
  }

  let(:param_attributes) {
    {
      user_id: user.id,
      commentable_type: "AureliusPress::Catalogue::Quote",
      commentable_id: quote.id,
      content: "A thoughtful comment.",
    }
  }

  let(:invalid_param_attributes) {
    {
      user_id: nil,
      commentable_type: "AureliusPress::Catalogue::Quote",
      commentable_id: quote.id,
      content: nil,
    }
  }

  describe "GET #index" do
    it "returns a successful response and assigns @comments" do
      create(:aurelius_press_fragment_comment, record_attributes)
      get :index
      expect(response).to be_successful
      expect(assigns(:comments)).to_not be_nil
      expect(assigns(:comments)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @comment" do
      comment = create(:aurelius_press_fragment_comment, record_attributes)
      get :show, params: { id: comment.id }
      expect(response).to be_successful
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment = create(:aurelius_press_fragment_comment, record_attributes)
      expect {
        delete :destroy, params: { id: comment.id }
      }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = create(:aurelius_press_fragment_comment, record_attributes)

      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to(aurelius_press_admin_fragment_comments_url)
    end
  end
  
  # Obselete tests for new/create and edit/update actions
  # describe "GET #new" do
  #   it "returns a successful response" do
  #     get :new
  #     expect(assigns(:comment)).to be_a_new(AureliusPress::Fragment::Comment)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid parameters" do
  #     it "creates a new Comment" do
  #       expect {
  #         post :create, params: { aurelius_press_fragment_comment: param_attributes }
  #       }.to change(AureliusPress::Fragment::Comment, :count).by(1)
  #     end

  #     it "redirects to the created comment" do
  #       post :create, params: { aurelius_press_fragment_comment: param_attributes }

  #       expect(response).to redirect_to(aurelius_press_admin_fragment_comment_path(AureliusPress::Fragment::Comment.last))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "does not create a new Comment" do
  #       expect {
  #         post :create, params: { aurelius_press_fragment_comment: invalid_param_attributes }
  #       }.to_not change(AureliusPress::Fragment::Comment, :count)
  #     end

  #     it "renders a response with 422 status (unprocessable_entity)" do
  #       post :create, params: { aurelius_press_fragment_comment: invalid_param_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response).to render_template(:new)
  #     end
  #   end
  # end

  # describe "GET #edit" do
  #   it "returns a successful response and assigns @comment" do
  #     comment = create(:aurelius_press_fragment_comment, record_attributes)
  #     get :edit, params: { id: comment.id }
  #     expect(response).to be_successful
  #     expect(assigns(:comment)).to eq(comment)
  #   end
  # end

  # describe "PATCH #update" do
  #   context "with valid parameters" do
  #     let!(:comment_to_update) { create(:aurelius_press_fragment_comment, record_attributes) }
  #     let(:new_valid_param_attributes) { { content: "An updated thoughtful comment." } }

  #     it "updates the requested comment" do
  #       patch :update, params: { id: comment_to_update.id, aurelius_press_fragment_comment: new_valid_param_attributes }
  #       comment_to_update.reload
  #       expect(comment_to_update.content.to_plain_text).to eq(new_valid_param_attributes[:content])
  #     end

  #     it "redirects to the comment" do
  #       patch :update, params: { id: comment_to_update.id, aurelius_press_fragment_comment: new_valid_param_attributes }

  #       expect(response).to redirect_to(aurelius_press_admin_fragment_comment_path(comment_to_update))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     let!(:comment_to_update) { create(:aurelius_press_fragment_comment, record_attributes) }

  #     it "renders a response with 422 status (unprocessable_entity)" do
  #       patch :update, params: { id: comment_to_update.id, aurelius_press_fragment_comment: invalid_param_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response).to render_template(:edit)
  #     end

  #     it "does not update the comment" do
  #       original_content = comment_to_update.content
  #       patch :update, params: { id: comment_to_update.id, aurelius_press_fragment_comment: invalid_param_attributes }
  #       comment_to_update.reload
  #       expect(comment_to_update.content).to eq(original_content)
  #     end
  #   end
  # end
end
