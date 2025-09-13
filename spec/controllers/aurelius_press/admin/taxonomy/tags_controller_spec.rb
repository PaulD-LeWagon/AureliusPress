require "rails_helper"

RSpec.describe AureliusPress::Admin::Taxonomy::TagsController, type: :controller do
  render_views

  let(:valid_attributes) { attributes_for(:aurelius_press_taxonomy_tag) }
  let(:invalid_attributes) { attributes_for(:aurelius_press_taxonomy_tag, name: nil) } # name is required
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:user) { create(:aurelius_press_user) }

  before do
    sign_in moderator
  end

  after do
    sign_out moderator
  end

  describe "GET #index" do
    it "returns a successful response and assigns @tags" do
      create(:aurelius_press_taxonomy_tag, name: "Test Tag 1")
      get :index
      expect(response).to be_successful
      expect(assigns(:tags)).to_not be_nil
      expect(assigns(:tags)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @tag" do
      tag = create(:aurelius_press_taxonomy_tag, name: "Test Tag 2")
      get :show, params: { id: tag.id }
      expect(response).to be_successful
      expect(assigns(:tag)).to eq(tag)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:tag)).to be_a_new(AureliusPress::Taxonomy::Tag)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Tag" do
        expect {
          post :create, params: { aurelius_press_taxonomy_tag: valid_attributes }
        }.to change(AureliusPress::Taxonomy::Tag, :count).by(1)
      end

      it "redirects to the created tag" do
        post :create, params: { aurelius_press_taxonomy_tag: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_taxonomy_tag_path(AureliusPress::Taxonomy::Tag.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Tag" do
        expect {
          post :create, params: { aurelius_press_taxonomy_tag: invalid_attributes }
        }.to_not change(AureliusPress::Taxonomy::Tag, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_taxonomy_tag: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @tag" do
      tag = create(:aurelius_press_taxonomy_tag, name: "Tag for Edit")
      get :edit, params: { id: tag.id }
      expect(response).to be_successful
      expect(assigns(:tag)).to eq(tag)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:tag_to_update) { create(:aurelius_press_taxonomy_tag, name: "Old Tag Name") }
      let(:new_attributes) { { name: "New Updated Tag Name" } }

      it "updates the requested tag" do
        patch :update, params: { id: tag_to_update.id, aurelius_press_taxonomy_tag: new_attributes }
        tag_to_update.reload
        expect(tag_to_update.name).to eq("New Updated Tag Name")
      end

      it "redirects to the tag" do
        patch :update, params: { id: tag_to_update.id, aurelius_press_taxonomy_tag: new_attributes }
        tag_to_update.reload # Reload to get the updated slug if name affects it
        expect(response).to redirect_to(aurelius_press_admin_taxonomy_tag_path(tag_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:tag_to_update) { create(:aurelius_press_taxonomy_tag, name: "Valid Tag Name") }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: tag_to_update.id, aurelius_press_taxonomy_tag: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the tag" do
        original_name = tag_to_update.name
        patch :update, params: { id: tag_to_update.id, aurelius_press_taxonomy_tag: invalid_attributes }
        tag_to_update.reload
        expect(tag_to_update.name).to eq(original_name)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tag" do
      tag = create(:aurelius_press_taxonomy_tag, name: "Tag to Destroy")
      expect {
        delete :destroy, params: { id: tag.id }
      }.to change(AureliusPress::Taxonomy::Tag, :count).by(-1)
    end

    it "redirects to the tags list" do
      tag = create(:aurelius_press_taxonomy_tag, name: "Tag for Redirect")
      delete :destroy, params: { id: tag.id }
      expect(response).to redirect_to(aurelius_press_admin_taxonomy_tags_url)
    end
  end
end
