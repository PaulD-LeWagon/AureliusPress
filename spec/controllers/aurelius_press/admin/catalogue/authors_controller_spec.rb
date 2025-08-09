require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::AuthorsController, type: :controller do
  # It's good practice to define a valid_attributes and invalid_attributes hash
  # for create/update tests later, but for now, we'll focus on basics.
  let(:valid_attributes) { attributes_for(:aurelius_press_catalogue_author) }
  let(:invalid_attributes) { attributes_for(:aurelius_press_catalogue_author, name: nil) }
  let!(:admin) { create(:aurelius_press_admin_user) }

  subject { create(:aurelius_press_catalogue_author, name: "Epictetus") }

  before do
    sign_in admin
  end

  after do
    sign_out admin
  end

  # Ensure the controller uses the correct module (Rails default for namespaced controllers)
  render_views

  describe "viewing attributes" do
    it "has valid valid_attributes" do
      expect(valid_attributes).to be_a(Hash)
      expect(valid_attributes[:name]).to be_present
      expect(valid_attributes[:bio]).to be_present
    end

    it "has valid invalid_attributes" do
      expect(invalid_attributes).to be_a(Hash)
      expect(invalid_attributes[:name]).to be_nil # Ensure name is nil for invalid attributes
      expect(invalid_attributes[:bio]).to be_present # Bio can still be present
    end
  end

  describe "GET #index" do
    it "returns a successful response" do
      # Create some test data using your FactoryBot author factory
      # e.g., create_list(:author, 3) if you have multiple authors
      authors = create_list(:aurelius_press_catalogue_author, 3)

      get :index
      expect(response).to be_successful
      expect(response.content_type).to eq "text/html; charset=utf-8" # Assuming HTML response
      expect(assigns(:authors)).to_not be_nil # Check that @authors is assigned
    end
  end

  describe "GET #show" do
    it "expects the subject (author) to be created - i.e. valid & persisted." do
      expect(subject).to be_valid
      expect(subject).to be_persisted # Ensure the author is saved in the database
    end

    it "returns a successful response - i.e retrieves the subject (author) from the database." do
      get :show, params: { id: subject.id }
      expect(response).to be_successful
      expect(assigns(:author)).to eq(subject) # Check that @author is assigned and is the correct author
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:author)).to be_a_new(AureliusPress::Catalogue::Author) # Checks if @author is a new record
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Author" do
        expect {
          post :create, params: { aurelius_press_catalogue_author: valid_attributes }
        }.to change(AureliusPress::Catalogue::Author, :count).by(1)
      end

      it "redirects to the created author" do
        post :create, params: { aurelius_press_catalogue_author: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_catalogue_author_path(AureliusPress::Catalogue::Author.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Author" do
        expect {
          post :create, params: { aurelius_press_catalogue_author: invalid_attributes }
        }.to_not change(AureliusPress::Catalogue::Author, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_catalogue_author: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new) # Renders the new template on failure
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @author" do
      author = create(:aurelius_press_catalogue_author, name: "Author for Edit")
      get :edit, params: { id: author.id }
      expect(response).to be_successful
      expect(assigns(:author)).to eq(author)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      # Create an author specifically for updating within this context
      let!(:author_to_update) { create(:aurelius_press_catalogue_author, name: "Old Name") }
      # Define new attributes for a successful update
      let(:new_attributes) { { name: "New Updated Name" } }

      it "updates the requested author" do
        patch :update, params: { id: author_to_update.id, aurelius_press_catalogue_author: new_attributes }
        author_to_update.reload # Reload the author from the database to get updated values
        expect(author_to_update.name).to eq("New Updated Name")
      end

      it "redirects to the author" do
        patch :update, params: { id: author_to_update.id, aurelius_press_catalogue_author: new_attributes }
        author_to_update.reload # Ensure we have the latest data
        expect(author_to_update.name).to eq("New Updated Name")
        expect(response).to redirect_to(aurelius_press_admin_catalogue_author_path(author_to_update))
      end
    end

    context "with invalid parameters" do
      # Create an author specifically for updating within this context
      let!(:author_to_update) { create(:aurelius_press_catalogue_author, name: "Valid Old Name") }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: author_to_update.id, aurelius_press_catalogue_author: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit) # Renders the edit template on failure
      end

      it "does not update the author" do
        original_name = author_to_update.name
        patch :update, params: { id: author_to_update.id, aurelius_press_catalogue_author: invalid_attributes }
        author_to_update.reload
        expect(author_to_update.name).to eq(original_name) # Name should remain unchanged
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested author" do
      author = create(:aurelius_press_catalogue_author, name: "Author to Destroy") # Create an author to be destroyed
      expect {
        delete :destroy, params: { id: author.id }
      }.to change(AureliusPress::Catalogue::Author, :count).by(-1)
    end

    it "redirects to the authors list" do
      author = create(:aurelius_press_catalogue_author, name: "Author for Redirect")
      delete :destroy, params: { id: author.id }
      expect(response).to redirect_to(aurelius_press_admin_catalogue_authors_url)
    end
  end

  describe "private methods" do
    it "sets the author for show, edit, update, and destroy actions" do
      author = create(:aurelius_press_catalogue_author, name: "Author for Set")
      get :show, params: { id: author.id }
      expect(assigns(:author)).to eq(author)

      get :edit, params: { id: author.id }
      expect(assigns(:author)).to eq(author)

      patch :update, params: { id: author.id, aurelius_press_catalogue_author: valid_attributes }
      expect(assigns(:author)).to eq(author)

      delete :destroy, params: { id: author.id }
      expect(assigns(:author)).to eq(author)
    end
  end
end
