require "rails_helper"

RSpec.describe AureliusPress::Admin::Taxonomy::CategoriesController, type: :controller do
  render_views # Ensure views are rendered for template checks

  # Define valid and invalid attributes for testing create/update actions
  # Adjust these based on your Category model's validations
  let(:valid_attributes) { attributes_for(:aurelius_press_taxonomy_category) }
  let(:invalid_attributes) { attributes_for(:aurelius_press_taxonomy_category, name: nil) } # name is required
  let(:moderator) { create(:aurelius_press_moderator_user) }
  let(:user) { create(:aurelius_press_user) }

  before do
    sign_in moderator
  end

  after do
    sign_out moderator
  end

  describe "GET #index" do
    it "returns a successful response and assigns @categories" do
      create(:aurelius_press_taxonomy_category, name: "Test Category 1")
      get :index
      expect(response).to be_successful
      expect(assigns(:categories)).to_not be_nil
      expect(assigns(:categories)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @category" do
      category = create(:aurelius_press_taxonomy_category, name: "Test Category 2")
      get :show, params: { id: category.id }
      expect(response).to be_successful
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:category)).to be_a_new(AureliusPress::Taxonomy::Category)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Category" do
        expect {
          post :create, params: { aurelius_press_taxonomy_category: valid_attributes }
        }.to change(AureliusPress::Taxonomy::Category, :count).by(1)
      end

      it "redirects to the created category" do
        post :create, params: { aurelius_press_taxonomy_category: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_taxonomy_category_path(AureliusPress::Taxonomy::Category.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Category" do
        expect {
          post :create, params: { aurelius_press_taxonomy_category: invalid_attributes }
        }.to_not change(AureliusPress::Taxonomy::Category, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_taxonomy_category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @category" do
      category = create(:aurelius_press_taxonomy_category, name: "Category for Edit")
      get :edit, params: { id: category.id }
      expect(response).to be_successful
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:category_to_update) { create(:aurelius_press_taxonomy_category, name: "Old Category Name") }
      let(:new_attributes) { { name: "New Updated Category Name" } }

      it "updates the requested category" do
        patch :update, params: { id: category_to_update.id, aurelius_press_taxonomy_category: new_attributes }
        category_to_update.reload
        expect(category_to_update.name).to eq("New Updated Category Name")
      end

      it "redirects to the category" do
        patch :update, params: { id: category_to_update.id, aurelius_press_taxonomy_category: new_attributes }
        category_to_update.reload # Reload to get the updated slug if name affects it
        expect(response).to redirect_to(aurelius_press_admin_taxonomy_category_path(category_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:category_to_update) { create(:aurelius_press_taxonomy_category, name: "Valid Category Name") }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: category_to_update.id, aurelius_press_taxonomy_category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the category" do
        original_name = category_to_update.name
        patch :update, params: { id: category_to_update.id, aurelius_press_taxonomy_category: invalid_attributes }
        category_to_update.reload
        expect(category_to_update.name).to eq(original_name)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      category = create(:aurelius_press_taxonomy_category, name: "Category to Destroy")
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(AureliusPress::Taxonomy::Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = create(:aurelius_press_taxonomy_category, name: "Category for Redirect")
      delete :destroy, params: { id: category.id }
      expect(response).to redirect_to(aurelius_press_admin_taxonomy_categories_url)
    end
  end
end
