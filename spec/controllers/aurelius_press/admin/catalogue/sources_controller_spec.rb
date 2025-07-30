require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::SourcesController, type: :controller do
  render_views

  # Define valid and invalid attributes for testing create/update actions
  let(:valid_attributes) { attributes_for(:aurelius_press_catalogue_source) }
  let(:invalid_attributes) { attributes_for(:aurelius_press_catalogue_source, title: nil) }

  describe "GET #index" do
    it "returns a successful response and assigns @sources" do
      create(:aurelius_press_catalogue_source, title: "Test Source 1", date: Date.today, source_type: "book")
      get :index
      expect(response).to be_successful
      expect(assigns(:sources)).to_not be_nil
      expect(assigns(:sources)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @source" do
      source = create(:aurelius_press_catalogue_source, title: "Test Source 2", date: Date.today, source_type: "essay")
      get :show, params: { id: source.id }
      expect(response).to be_successful
      expect(assigns(:source)).to eq(source)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:source)).to be_a_new(AureliusPress::Catalogue::Source)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Source" do
        expect {
          post :create, params: { aurelius_press_catalogue_source: valid_attributes }
        }.to change(AureliusPress::Catalogue::Source, :count).by(1)
      end

      it "redirects to the created source" do
        post :create, params: { aurelius_press_catalogue_source: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_catalogue_source_path(AureliusPress::Catalogue::Source.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Source" do
        expect {
          post :create, params: { aurelius_press_catalogue_source: invalid_attributes }
        }.to_not change(AureliusPress::Catalogue::Source, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_catalogue_source: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @source" do
      source = create(:aurelius_press_catalogue_source, title: "Source for Edit", date: Date.today, source_type: "article")
      get :edit, params: { id: source.id }
      expect(response).to be_successful
      expect(assigns(:source)).to eq(source)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:source_to_update) { create(:aurelius_press_catalogue_source, title: "Old Title", date: Date.today, source_type: "blog") }
      let(:new_attributes) { { title: "New Updated Title", source_type: "book" } }

      it "updates the requested source" do
        patch :update, params: { id: source_to_update.id, aurelius_press_catalogue_source: new_attributes }
        source_to_update.reload
        expect(source_to_update.title).to eq("New Updated Title")
        expect(source_to_update.source_type).to eq("book")
      end

      it "redirects to the source" do
        patch :update, params: { id: source_to_update.id, aurelius_press_catalogue_source: new_attributes }
        source_to_update.reload
        expect(source_to_update.title).to eq("New Updated Title")
        expect(source_to_update.source_type).to eq("book")
        expect(response).to redirect_to(aurelius_press_admin_catalogue_source_path(source_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:source_to_update) { create(:aurelius_press_catalogue_source, title: "Valid Title", date: Date.today, source_type: "journal") }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: source_to_update.id, aurelius_press_catalogue_source: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the source" do
        original_title = source_to_update.title
        patch :update, params: { id: source_to_update.id, aurelius_press_catalogue_source: invalid_attributes }
        source_to_update.reload
        expect(source_to_update.title).to eq(original_title)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested source" do
      source = create(:aurelius_press_catalogue_source, title: "Source to Destroy", date: Date.today, source_type: "poem")
      expect {
        delete :destroy, params: { id: source.id }
      }.to change(AureliusPress::Catalogue::Source, :count).by(-1)
    end

    it "redirects to the sources list" do
      source = create(:aurelius_press_catalogue_source, title: "Source for Redirect", date: Date.today, source_type: "newsletter")
      delete :destroy, params: { id: source.id }
      expect(response).to redirect_to(aurelius_press_admin_catalogue_sources_url)
    end
  end
end
